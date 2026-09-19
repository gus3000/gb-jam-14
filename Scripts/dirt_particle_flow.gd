extends GPUParticles2D

@export var displacement_max_magnitude: float = 3

@onready var gold_pan: Node2D = $"../GoldPan"
@onready var player: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	player.bag.dirt_amount_changed.connect(_on_bag_dirt_amount_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# set_instance_shader_parameter("target_position", gold_pan.global_position)
	process_material.set_shader_parameter("target_position", gold_pan.pot_position + Vector2.UP * 8)
# set_instance_shader_parameter("shader_parameter/target_position", gold_pan.global_position)


func _on_bag_dirt_amount_changed(dirt_amount: int):
	if dirt_amount >= 0:
		return
	var particles_to_generate: int = max(1, log(-dirt_amount))
	for i in range(particles_to_generate):
		emit_particle(
				Transform2D(0, get_particle_start_position()),
				Vector2.UP,
				Color.BLACK,
				Color.BLACK,
				EMIT_FLAG_POSITION | EMIT_FLAG_VELOCITY
		)


func get_particle_start_position() -> Vector2:
	var base_pos := player.bag.opening.global_position

	var displacement_angle: float = randf_range(0, TAU)
	var displacement_magnitude: float = randf_range(0.01, displacement_max_magnitude)
	base_pos += Vector2.from_angle(displacement_angle) * displacement_magnitude

	return base_pos
