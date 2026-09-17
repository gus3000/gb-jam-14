class_name CameraRig
extends Camera2D

@export var target: Node2D
@export var still_shape: Rect2i
@export var shake_curve: Curve2D
@export var shake_intensity: float = 30.
@export var shake_decay: float = 5.
@export var snap_force: float = 5.
@export var minimal_movement_per_frame: float = 3.

var update_vertical: bool = true
var current_shake_strength: float = 0.0
var current_shake_position: float = -100000.0
var focused_interact_points: Array[InteractPoint] = []
var has_focused_interact_points: bool:
	get: return not focused_interact_points.is_empty()
var focused_interact_point: InteractPoint:
	get:
		if not has_focused_interact_points:
			return null
		return focused_interact_points.back()

# var target_local_coords: Vector2:
# 	get: return to_local(target.global_position)

func _ready() -> void:
	GameController.world_shuffle.connect(_on_world_shuffle)
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

func _process(delta: float) -> void:
	move_toward_target(delta)

	# current_shake_strength = lerp(current_shake_strength,0., shake_decay * _delta)
	current_shake_strength = shake_curve.sample_baked(current_shake_position).y * shake_intensity
	# print("shake sample at ", current_shake_position, " -> ", shake_curve.sample_baked(current_shake_position))
	current_shake_position += delta
	offset = Vector2(
			randf_range(-current_shake_strength, current_shake_strength),
			randf_range(-current_shake_strength, current_shake_strength),
	)
	pass

func move_toward_target(delta: float) -> void:
	var target_position: Vector2
	if not has_focused_interact_points:
		var travel_vector := get_travel_vector()
		# print("travel_vector : ", travel_vector)
		print("targeting player")
		target_position = global_position + travel_vector
	else:
		print("targeting inteact point ", focused_interact_point)
		target_position = focused_interact_point.global_position
	var target_lerped_position: Vector2 = lerp(position, target_position, snap_force * delta)
	var actual_travel_vector := target_lerped_position - global_position
	print("target movement :", global_position, " -> ", target_position)
	print("travel vector :", actual_travel_vector)
	if (target_position - global_position).length() <= minimal_movement_per_frame:
		global_position = target_position
		return
	if actual_travel_vector.length() < minimal_movement_per_frame:
		actual_travel_vector *= minimal_movement_per_frame / actual_travel_vector.length()
	print("actual travel vector :", actual_travel_vector)
	global_position += actual_travel_vector

func get_travel_vector() -> Vector2:
	var local := to_local(target.global_position)

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

func _on_game_controller_enter_fixed_scene() -> void:
	print("enter fixed scene")
	update_vertical = false
	pass

func _on_game_controller_leave_fixed_scene() -> void:
	update_vertical = true
	pass

func _on_world_shuffle() -> void:
	# print("camera world shuffle")
	current_shake_strength = shake_intensity
	current_shake_position = 0
	pass

func focus(interact_point: InteractPoint):
	focused_interact_points.push_back(interact_point)

func unfocus(interact_point: InteractPoint):
	focused_interact_points.erase(interact_point)
