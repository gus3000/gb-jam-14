class_name GoldPan
extends Node2D

@export var dirt_filter_bag_percent_acceleration: float = .01

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var bag: Bag = GameController.player.bag

var gold: int = 0
var filtering: bool = false
var filtering_speed: int = 0

func start():
	filtering = false
	animationPlayer.play("StartHover")
	await animationPlayer.animation_finished
	filtering = true
	animationPlayer.play("Hover")

func stop():
	filtering = false
	filtering_speed = 0
	animationPlayer.stop()
	animationPlayer.play_backwards("StartHover")

func _process(_delta: float) -> void:
	if bag.dirt == 0 and filtering_speed > 0:
		stop()
		return
	if bag.dirt == 0 and filtering_speed == 0:
		return
	filtering_speed += bag.max_dirt * dirt_filter_bag_percent_acceleration * _delta as int
	bag.extract_dirt(filtering_speed * _delta as int)
	