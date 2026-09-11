extends CharacterBody2D

@export var SPEED: int = 100 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("left"):
		velocity.x -= SPEED
	elif event.is_action_released("left"):
		velocity.x += SPEED
	if event.is_action_pressed("right"):
		velocity.x += SPEED
	if event.is_action_released("right"):
		velocity.x -= SPEED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity.y = 98
	move_and_slide()
