extends CharacterBody2D

const Direction := Utils.Direction
const PlayerAnimation := PlayerSprite.PlayerAnimation

signal started_mining
signal current_animation(player_animation: PlayerAnimation, direction: Direction)

@export var SPEED: int = 100
@export var GRAVITY: int = 1000
@export var RANGE: int = 32
@export_custom(PROPERTY_HINT_NONE, "suffix:ms") var MINING_COOLDOWN: int = 300
@export var JUMP_FORCE: int = 200
@export var HOLDING_JUMP_FORCE: int = 400
@export var debug_point: Sprite2D

var facing_direction: Direction = Direction.RIGHT
var last_left_right_direction: Direction = Direction.RIGHT
var mining: bool = false
var jumping: bool = false
var walking: bool = false
var holding_jump: bool = false
var last_mined_block_timestamp: int = 0

@onready var raycast_up: RayCast2D = $Rays/Up
@onready var raycast_down: RayCast2D = $Rays/Down
@onready var raycast_left_bottom: RayCast2D = $Rays/LeftBottom
@onready var raycast_left_top: RayCast2D = $Rays/LeftTop
@onready var raycast_right_bottom: RayCast2D = $Rays/RightBottom
@onready var raycast_right_top: RayCast2D = $Rays/RightTop

var raycasts: Dictionary = {}

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

var looked_at_tilemap: MineableTimeMap:
	get:
		if looked_at_point == Vector2.ZERO:
			return null
		return looked_at_raycast.get_collider()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	raycasts = {
		Direction.UP: [raycast_up],
		Direction.DOWN: [raycast_down],
		Direction.LEFT: [raycast_left_bottom, raycast_left_top],
		Direction.RIGHT: [raycast_right_bottom, raycast_right_top],
	}


func _input(event: InputEvent) -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(global_position)
	handle_horizontal_movement()
	mining = Input.is_action_pressed("mine")
	handle_vertical_movement()

	handle_animation_state()
	highlight_minable_block()
	pass

func handle_horizontal_movement() -> void:
	velocity.x = Input.get_axis("left", "right") * SPEED
	if velocity.x != 0:
		facing_direction = Direction.LEFT if velocity.x < 0 else Direction.RIGHT
		last_left_right_direction = facing_direction
		walking = true
	else:
		walking = false

func handle_vertical_movement() -> void:
	if is_on_floor():
		jumping = false

	jumping = not jumping and Input.is_action_just_pressed("jump")
	holding_jump = Input.is_action_pressed("jump")
	var looking: float = Input.get_axis("up", "down")
	if looking != 0:
		facing_direction = Direction.UP if looking < 0 else Direction.DOWN
	elif facing_direction in [Direction.LEFT,
		Direction.RIGHT]:  # we stopped looking up or down, let's reset to the last left or right
		facing_direction = last_left_right_direction

func handle_animation_state() -> void:
	if jumping:
		current_animation.emit(PlayerAnimation.JUMP, facing_direction)
		return
	if not is_on_floor():
		current_animation.emit(PlayerAnimation.FALL, facing_direction)
		return
	if walking:
		current_animation.emit(PlayerAnimation.WALK, facing_direction)
		return
	current_animation.emit(PlayerAnimation.IDLE, facing_direction)
	pass

#region ///mining
func handle_mining() -> void:
	var now: int = Time.get_ticks_msec()
	if now - last_mined_block_timestamp >= MINING_COOLDOWN:
		last_mined_block_timestamp = now
		mine_block()

func mine_block() -> void:
	print("trying to mine", Utils.string_from_direction(facing_direction))
	print("thus using raycast", looked_at_raycast)
	if not looked_at_raycast != null:
		print("not colliding")
		return
	var collide_point := looked_at_point
	print("point to mine :", collide_point)
	if collide_point == null:
		return
	# print("with normal", looked_at_raycast.get_collision_normal())
	# collide_point -= looked_at_raycast.get_collision_normal()
	print("collider to mine :", looked_at_raycast.get_collider())

	started_mining.emit()
	looked_at_tilemap.mine_block(collide_point)

func highlight_minable_block() -> void:
	var l := looked_at_point
	if l == Vector2.ZERO or looked_at_tilemap == null:
		debug_point.visible = false
		return
	# print(looked_at_point)
	debug_point.visible = true
	debug_point.global_position = looked_at_tilemap.get_block_position(l)
#endregion

func handle_jumping(delta: float) -> void:
	if jumping:
		velocity.y = -JUMP_FORCE
		print("jumping !")
	elif holding_jump:
		velocity.y -= (HOLDING_JUMP_FORCE * delta)
	# print("holding jump")
	pass

func _physics_process(delta: float) -> void:
	if mining:
		handle_mining()
	if jumping or holding_jump:
		handle_jumping(delta)
	velocity.y = min(velocity.y + GRAVITY * delta, GRAVITY)
	# print("facing direction :", Utils.string_from_direction(facing_direction))
	move_and_slide()
	pass
