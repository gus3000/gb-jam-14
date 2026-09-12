extends Camera2D

@export var target:Node2D
@export var max_speed:int = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var travel_vector: Vector2 = target.position - position
	var max_speed_ratio: float = travel_vector.length() / (max_speed*delta)
	if max_speed_ratio > 1:
		travel_vector /= max_speed_ratio
	position += travel_vector
	pass	
