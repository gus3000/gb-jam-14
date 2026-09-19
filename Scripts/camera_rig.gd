class_name CameraRig
extends Camera2D

@export var target: Node2D
@export var still_shape: Rect2i
@export var shake_curve: Curve2D
@export var shake_intensity: float = 5.
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
	if is_instance_of(get_parent(), Overworld):
		get_tree().get_first_node_in_group("main_scene").world_shuffle.connect(_on_world_shuffle)
	pass  # Replace with function body.

func _draw() -> void:
	if not OS.is_debug_build():
		return
	return

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
		target_position = global_position + travel_vector
	else:
		target_position = focused_interact_point.global_position
	var target_lerped_position: Vector2 = lerp(position, target_position, snap_force * delta)
	var actual_travel_vector := target_lerped_position - global_position
	if (target_position - global_position).length() <= minimal_movement_per_frame:
		global_position = target_position
		return
	if actual_travel_vector.length() < minimal_movement_per_frame:
		actual_travel_vector *= minimal_movement_per_frame / actual_travel_vector.length()
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
	# print("enter fixed scene")
	update_vertical = false
	pass

func _on_game_controller_leave_fixed_scene() -> void:
	update_vertical = true
	pass

func _on_world_shuffle(intensity: float=-1) -> void:
	# print("camera world shuffle")
	if intensity > 0:
		intensity = shake_intensity
	current_shake_strength = intensity
	current_shake_position = 0
	pass

func focus(interact_point: InteractPoint):
	focused_interact_points.push_back(interact_point)

func unfocus(interact_point: InteractPoint):
	focused_interact_points.erase(interact_point)
