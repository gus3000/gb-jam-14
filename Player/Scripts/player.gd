extends CharacterBody2D

const Utils := preload("res://Scripts/utils.gd")
const Direction := Utils.Direction

@export var SPEED: int = 100
@export var GRAVITY: int = 100
@export_custom(PROPERTY_HINT_NONE, "suffix:ms") var MINING_COOLDOWN: int = 600

var mining: bool = false
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
	pass

func handle_horizontal_movement() -> void:
	if Input.is_action_just_pressed("left"):
		velocity.x -= SPEED
	elif Input.is_action_just_released("left"):
		velocity.x += SPEED
	if Input.is_action_just_pressed("right"):
		velocity.x += SPEED
	if Input.is_action_just_released("right"):
		velocity.x -= SPEED
	velocity.x = clamp(velocity.x, -SPEED, SPEED)


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
	var query := PhysicsRayQueryParameters2D.create(position, position + Utils.vector2_from_direction(direction))
	query.exclude = [self]

	var result := space_state.intersect_ray(query)
	print(result)
	var collided := result.collider as MineableTimeMap
	collided.mine_block(result.position)
	

func _physics_process(delta: float) -> void:
	if mining:
		handle_mining(Direction.DOWN)
	velocity.y = GRAVITY
	move_and_slide()
	pass
