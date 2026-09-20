class_name Player
extends CharacterBody2D

const Direction := Utils.Direction
const PlayerAnimation := PlayerSprite.PlayerAnimation
const KeyObjectType := KeyObject.KeyObjectType
const Power := PowerCore.Power

signal current_animation(player_animation: PlayerAnimation, direction: Direction)
signal obtain_key_object(object_type: KeyObjectType)
signal observation(message: String)
signal changed_equipped_power(power: Power)
signal movement_just_paused(paused: bool)
signal gained_gold
signal failed
signal started_jetpack
signal stopped_jetpack
signal started_walking
signal stopped_walking
signal jumped

@export var SPEED: int = 100
@export var GRAVITY: int = 1000
@export var RANGE: int = 32
@export var JUMP_FORCE: int = 200
@export var HOLDING_JUMP_FORCE: int = 400
@export var LAND_ANIMATION_TIME: int = 500  #ms

var facing_direction: Direction = Direction.RIGHT
var last_left_right_direction: Direction = Direction.RIGHT
var jumping: bool = false
var walking: bool = false
var holding_jump: bool = false

@onready var power_core: PowerCore = $PowerCore
@onready var mining_core: MiningCore = $PowerCore/MiningCore
@onready var bag: Bag = $PowerCore/Bag

@onready var raycast_up: RayCast2D = $Rays/Up
@onready var raycast_down: RayCast2D = $Rays/Down
@onready var raycast_left_bottom: RayCast2D = $Rays/LeftBottom
@onready var raycast_left_top: RayCast2D = $Rays/LeftTop
@onready var raycast_right_bottom: RayCast2D = $Rays/RightBottom
@onready var raycast_right_top: RayCast2D = $Rays/RightTop

var raycasts: Dictionary = {}

var last_landing_time: = 0
var is_on_floor_history: Array[bool] = [true, true]
var number_of_pauses: int = 0
var movement_paused: bool = false:
	get: return number_of_pauses > 0
	set(value):
		# print("(%s) pre-pause n=%s" % [value, number_of_pauses])
		if value:
			if number_of_pauses == 0:
				movement_just_paused.emit(value)
			number_of_pauses += 1
		else:
			if number_of_pauses == 1:
				movement_just_paused.emit(value)
			number_of_pauses -= 1
		# print("post-pause n=", number_of_pauses)

var looked_at_raycasts: Array[RayCast2D]:
	get:
		#stupid workaround cause Godot arrays are stupid
		var out: Array[RayCast2D]
		out.assign(raycasts[facing_direction])
		return out

var looked_at_raycast: RayCast2D:
	get:
		for ray in looked_at_raycasts:
			if ray.is_colliding():
				return ray
		return null

var looked_at_point: Vector2:
	get:
		if looked_at_raycast == null:
			return Vector2.ZERO
		return looked_at_raycast.get_collision_point() - looked_at_raycast.get_collision_normal()

var looked_at_tilemap: DiggableTileMap:
	get:
		if looked_at_point == Vector2.ZERO:
			return null
		var col := looked_at_raycast.get_collider()
		if col is not DiggableTileMap:
			return null
		return col

var was_on_floor_last_frame: bool:
	get: return is_on_floor_history.front()

var gold: int = 0:
	set(value):
		GameController.gold_changed.emit(value)
		gold = value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	raycasts = {
		Direction.UP: [raycast_up],
		Direction.DOWN: [raycast_down],
		Direction.LEFT: [raycast_left_bottom, raycast_left_top],
		Direction.RIGHT: [raycast_right_bottom, raycast_right_top],
	}


#func _input(event: InputEvent) -> void:
#	pass

func _physics_process(delta: float) -> void:
	if movement_paused:
		return
	handle_horizontal_movement()
	handle_vertical_movement()

	is_on_floor_history.pop_front()
	is_on_floor_history.push_back(is_on_floor())
	if jumping or holding_jump:
		handle_jumping(delta)
	velocity.y = min(velocity.y + GRAVITY * delta, GRAVITY)
	move_and_slide()
	pass

func _process(_delta: float) -> void:
	handle_animation_state()
	pass

func handle_horizontal_movement() -> void:
	var speed: int = SPEED
	var jetpack_speed: float = power_core.jetpack_core.jetpack_speed
	if power_core.equipped_power == Power.JETPACK and power_core.powering:
		speed = jetpack_speed as int
	if not is_on_floor():
		speed = max(abs(velocity.x), speed)
	velocity.x = round(Input.get_axis("left", "right")) * speed
	if velocity.x != 0:
		facing_direction = Direction.LEFT if velocity.x < 0 else Direction.RIGHT
		last_left_right_direction = facing_direction
		if not walking:
			started_walking.emit()
		walking = true
	else:
		if walking:
			stopped_walking.emit()
		walking = false

func handle_vertical_movement() -> void:
	if (not was_on_floor_last_frame) and is_on_floor_history.back():
		#we just landed
		last_landing_time = Time.get_ticks_msec()

	jumping = is_on_floor() and Input.is_action_just_pressed("gb_a")
	if jumping:
		jumped.emit()
	holding_jump = Input.is_action_pressed("gb_a")
	var looking: float = Input.get_axis("up", "down")

	if looking != 0:
		facing_direction = Direction.UP if looking < 0 else Direction.DOWN
	elif facing_direction in [Direction.LEFT, Direction.RIGHT]:
		# we stopped looking up or down, let's reset to the last left or right
		facing_direction = last_left_right_direction

func handle_animation_state() -> void:
	if movement_paused:
		return
	if power_core.equipped_power == Power.SHOVEL and power_core.powering:
		current_animation.emit(PlayerAnimation.MINE, facing_direction)
		return
	if jumping:
		current_animation.emit(PlayerAnimation.JUMP, facing_direction)
		return
	if not is_on_floor():
		current_animation.emit(PlayerAnimation.FALL, facing_direction)
		return
	if walking:
		current_animation.emit(PlayerAnimation.WALK, facing_direction)
		return
	if is_on_floor_history.back() and (Time.get_ticks_msec() - last_landing_time <= LAND_ANIMATION_TIME):
		current_animation.emit(PlayerAnimation.LAND, facing_direction)
		return
	current_animation.emit(PlayerAnimation.IDLE, facing_direction)
	pass

func handle_jumping(delta: float) -> void:
	if jumping:
		velocity.y = -JUMP_FORCE
	# print("jumping !")
	elif holding_jump:
		velocity.y -= (HOLDING_JUMP_FORCE * delta)
	pass

func obtain(object_type: KeyObjectType):
	obtain_key_object.emit(object_type)
	movement_paused = true
	await get_tree().create_timer(2).timeout
	movement_paused = false
	pass

func has_key_object(object_type: KeyObjectType) -> bool:
	return bag.has_key_object(object_type)

func unlock_cheat() -> void:
	for core in power_core.cores:
		core.power_level = core.max_power_level
	bag.power_level = bag.max_power_level
	for object_type in KeyObjectType.values():
		bag._on_player_obtain_key_object(object_type)
	observation.emit("Unlocked\neverything !")
	GameController.earthquake()

func unlock_baby_cheat() -> void:
	for core in power_core.cores:
		core.power_level = 1
	bag.power_level = 1
	for object_type in KeyObjectType.values():
		bag._on_player_obtain_key_object(object_type)
	observation.emit("Unlocked\nbasic stuff !")

func add_gold(to_add: int):
	gold += to_add
	gained_gold.emit()

func _on_power_core_changed_equipped_power(power: Power) -> void:
	changed_equipped_power.emit(power)


func _on_jetpack_core_started() -> void:
	started_jetpack.emit()


func _on_jetpack_core_stopped() -> void:
	stopped_jetpack.emit()
