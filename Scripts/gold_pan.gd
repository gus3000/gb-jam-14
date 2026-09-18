class_name GoldPan
extends Node2D

@export var dirt_filter_bag_percent_acceleration: float = .01

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var bag: Bag = GameController.player.bag

var filtering: bool = false
var filtering_speed: int = 0

func start():
	filtering = false
	animationPlayer.play("StartHover")
	await animationPlayer.animation_finished
	GameController.earthquake()
	filtering = true
	animationPlayer.play("Hover")

func stop():
	filtering = false
	filtering_speed = 0
	animationPlayer.stop()
	animationPlayer.play_backwards("StartHover")
	await animationPlayer.animation_finished
	print("animation player speed is %s" % [animationPlayer.speed_scale])


func _process(_delta: float) -> void:
	if bag.dirt == 0 and filtering:
		stop()
		return
	if not filtering:
		return
	filtering_speed += ceili(bag.max_dirt * dirt_filter_bag_percent_acceleration * _delta)
	GameController.player.gold += bag.extract_dirt(ceili(filtering_speed * _delta))
	
