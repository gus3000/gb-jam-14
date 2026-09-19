class_name GoldPan
extends Node2D

@export var dirt_filter_bag_percent_acceleration: float = .01

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var pot: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: Player = get_parent().overworld.player

var filtering: bool = false
var filtering_speed: int = 0

var pot_position: Vector2:
	get:
		return pot.global_position

func start():
	filtering = false
	animationPlayer.play("StartHover")
	await animationPlayer.animation_finished
	filtering = true
	animationPlayer.play("Hover")

func stop():
	await get_tree().create_timer(3).timeout
	filtering = false
	filtering_speed = 0
	animationPlayer.stop()
	animationPlayer.play_backwards("StartHover")
	await animationPlayer.animation_finished


func _process(_delta: float) -> void:
	if player.bag.dirt == 0 and filtering:
		stop()
		return
	if not filtering:
		return
	filtering_speed += ceili(player.bag.max_dirt * dirt_filter_bag_percent_acceleration * _delta)

	# GameController.player.gold += bag.extract_dirt(ceili(filtering_speed * _delta))
	var to_add: int = player.bag.extract_dirt(ceili(filtering_speed * _delta))
	get_tree().create_timer(4).timeout.connect(func(): player.add_gold(to_add))
