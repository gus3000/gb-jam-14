class_name CameraRig
extends Camera2D

@export var target: Node2D
@export var still_shape: Rect2i

var update_vertical: bool = true

var target_local_coords: Vector2:
	get: return to_local(target.global_position)

func _ready() -> void:
	pass  # Replace with function body.

func _draw() -> void:
	if not OS.is_debug_build():
		return

	return
#region ///DEBUG
# var color: Color = Color.RED
# var width: float = 1
# var top_left := still_shape.position
# var top_right := Vector2i(top_left.x + still_shape.size.x, top_left.y)
# var bottom_left := Vector2i(top_left.x, top_left.y + still_shape.size.y)
# var bottom_right := Vector2i(top_left.x + still_shape.size.x, top_left.y + still_shape.size.y)
# 
# draw_circle(top_left, width, color, true, width, false)
# draw_circle(top_right, width, color, true, width, false)
# draw_circle(bottom_left, width, color, true, width, false)
# draw_circle(bottom_right, width, color, true, width, false)
# 
# draw_line(top_left, top_right, color, width, false)
# draw_line(top_left, bottom_left, color, width, false)
# draw_line(bottom_right, bottom_left, color, width, false)
# draw_line(bottom_right, top_right, color, width, false)
# 
# draw_line(Vector2.ZERO, get_travel_vector(0.05), Color.DARK_CYAN, 2, false)
#endregion

func get_travel_vector() -> Vector2:

	var local := target_local_coords

	var x: float = 0
	var y: float = 0

	if local.x < still_shape.position.x:
		x = local.x - still_shape.position.x
	elif local.x > still_shape.end.x:
		x = local.x - still_shape.end.x

	if update_vertical:
		if local.y < still_shape.position.y:
			y = local.y - still_shape.position.y
		elif local.y > still_shape.end.y:
			y = local.y - still_shape.end.y

	return Vector2(x, y)

func _process(_delta: float) -> void:
	var travel_vector := get_travel_vector()
	# print("travel_vector : ", travel_vector)
	position += travel_vector
	pass

func _on_game_controller_enter_fixed_scene() -> void:
	print("enter fixed scene")
	update_vertical = false
	pass

func _on_game_controller_leave_fixed_scene() -> void:
	update_vertical = true
	pass
