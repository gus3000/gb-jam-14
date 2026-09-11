extends CharacterBody2D

const Direction := Utils.Direction

@export var SPEED: int = 100
@export var GRAVITY: int = 1000
@export var RANGE: int = 32
@export_custom(PROPERTY_HINT_NONE, "suffix:ms") var MINING_COOLDOWN: int = 600
@export var JUMP_FORCE: int = 200
@export var HOLDING_JUMP_FORCE: int = 400

var facing_direction: Direction = Direction.RIGHT
var mining: bool = false
var jumping: bool = false
var holding_jump: bool = false
var last_mined_block_timestamp: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Replace with function body.


func _input(event: InputEvent) -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	handle_horizontal_movement()
	mining = Input.is_action_pressed("mine")
	handle_vertical_movement()

	pass

func handle_horizontal_movement() -> void:
	velocity.x = Input.get_axis("left", "right") * SPEED
	if velocity.x != 0:
		facing_direction = Direction.LEFT if velocity.x < 0 else Direction.RIGHT

func handle_vertical_movement() -> void:
	if is_on_floor():
		jumping = false

	jumping = not jumping and Input.is_action_just_pressed("jump")
	holding_jump = Input.is_action_pressed("jump")
	var looking: float = Input.get_axis("up", "down")
	if looking != 0:
		facing_direction = Direction.UP if looking < 0 else Direction.DOWN

#region ///mining
func handle_mining(direction: Direction) -> void:
	var now: int = Time.get_ticks_msec()
	if now - last_mined_block_timestamp >= MINING_COOLDOWN:
		last_mined_block_timestamp = now
		mine_block(direction)

func get_mined_point(direction: Direction) -> Dictionary:
	var space_state := get_world_2d().direct_space_state
	var query := PhysicsRayQueryParameters2D.create(global_position,
			global_position + Utils.vector2_from_direction(direction) * RANGE)
	query.exclude = [self]

	var result := space_state.intersect_ray(query)
	# print(result)
	return result

func mine_block(direction: Direction) -> void:
	print("trying to mine", Utils.string_from_direction(direction))
	var collide_point := get_mined_point(direction)
	if not "position" in collide_point or not "collider" in collide_point:
		return
	var collided := collide_point.collider as MineableTimeMap
	collided.mine_block(collide_point.position)
#endregion

func handle_jumping(delta: float) -> void:
	if jumping:
		velocity.y = -JUMP_FORCE
		print("jumping !")
	elif holding_jump:
		velocity.y -= (HOLDING_JUMP_FORCE * delta)
		print("holding jump")
	pass

func _physics_process(delta: float) -> void:
	if mining:
		handle_mining(facing_direction)
	if jumping or holding_jump:
		handle_jumping(delta)
	velocity.y = min(velocity.y + GRAVITY * delta, GRAVITY)
	# print("facing direction :", Utils.string_from_direction(facing_direction))
	move_and_slide()
	pass
