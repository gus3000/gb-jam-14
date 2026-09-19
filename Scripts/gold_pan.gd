class_name GoldPan
extends Node2D

signal finished

# @export var dirt_filter_bag_percent_acceleration: float = .01
@export var seconds_to_empty: float = 4

@onready var dirt_particle_flow: DirtParticleFlow = $"../DirtParticleFlow"
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var pot: AnimatedSprite2D = $AnimatedSprite2D
@onready var bag: Bag = GameController.player.bag

var filtering: bool = false

var pot_position: Vector2:
	get:
		return pot.global_position

func start():
	filtering = false
	animationPlayer.play("StartHover")
	await animationPlayer.animation_finished
	filtering = true
	animationPlayer.play("Hover")
	dirt_particle_flow.burst(seconds_to_empty)

func stop():
	await get_tree().create_timer(3).timeout
	filtering = false
	animationPlayer.stop()
	animationPlayer.play_backwards("StartHover")
	await animationPlayer.animation_finished
	finished.emit()


func _process(_delta: float) -> void:
	if bag.dirt == 0 and filtering:
		stop()
		return
	if not filtering:
		return

	# GameController.player.gold += bag.extract_dirt(ceili(filtering_speed * _delta))
	var to_add: int = bag.extract_dirt(ceili((bag.max_dirt / seconds_to_empty) * _delta))
	get_tree().create_timer(2).timeout.connect(func(): GameController.player.add_gold(to_add))
