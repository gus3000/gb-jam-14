extends Node2D

signal player_left_world

@export var world_min_x: float = 0
@export var world_max_x: float = 10000
@export var world_min_y: float = -10000
@export var world_max_y: float = 10000

func _ready() -> void:
	# print("readying world border")
	player_left_world.connect(GameController.player_exited_world)


func player_in_bounds() -> bool:
	var player_position := GameController.player.position
	return Rect2(
			world_min_x,
			world_min_y,
			world_max_x - world_min_x,
			world_max_y - world_min_y
	).has_point(
			player_position)

func _physics_process(_delta: float) -> void:
	if not player_in_bounds():
		player_left_world.emit()
	pass
