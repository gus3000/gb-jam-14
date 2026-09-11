extends CharacterBody2D

const Utils := preload("res://Scripts/utils.gd")
const Direction := Utils.Direction

@export var SPEED: int = 100
@export var GRAVITY: int = 1000
@export var RANGE: int = 32
@export_custom(PROPERTY_HINT_NONE, "suffix:ms") var MINING_COOLDOWN: int = 600
@export var JUMP_FORCE: int = 200
@export var HOLDING_JUMP_FORCE: int = 400

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

func handle_vertical_movement() -> void:
	if is_on_floor():
		jumping = false

	jumping = not jumping and Input.is_action_just_pressed("jump")
	holding_jump = Input.is_action_pressed("jump")

func handle_mining(direction: Direction) -> void:
	var now: int = Time.get_ticks_msec()
	if now - last_mined_block_timestamp >= MINING_COOLDOWN:
		last_mined_block_timestamp = now
		mine_block(direction)

func get_mined_block(direction: Direction):
	#TODO
	pass

func mine_block(direction: Direction) -> void:
	var space_state := get_world_2d().direct_space_state
	var query := PhysicsRayQueryParameters2D.create(global_position,
			global_position + Utils.vector2_from_direction(direction) * RANGE)
	query.exclude = [self]

	var result := space_state.intersect_ray(query)
	print(result)
	if not "position" in result or not "collider" in result:
		return
	var collided := result.collider as MineableTimeMap
	collided.mine_block(result.position)

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
		handle_mining(Direction.DOWN)
	if jumping or holding_jump:
		handle_jumping(delta)
	velocity.y = min(velocity.y + GRAVITY * delta, GRAVITY)
	move_and_slide()
	pass
