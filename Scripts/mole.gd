@tool
class_name Mole
extends Node2D

signal hit_ground

@onready var animation_player: AnimationPlayer = $AnimationPlayer
# @onready var sprite: Sprite2D = $Sprite

func _ready() -> void:
	hit_ground.connect(AudioController._on_mole_hit_ground)
	animation_player.play("Appear")
	

func flee() -> void:
	# sprite.play("Flee")
	animation_player.play("Flee")
	# await get_tree().create_timer(.5).timeout
	# AudioController._on_mole_fled()
	await animation_player.animation_finished
	queue_free()
	pass


func _on_detection_body_entered(body: Node2D) -> void:
	if not is_instance_of(body, Player):
		return
	print("player detected !")
	flee()

func _hit_ground()->void:
	hit_ground.emit()
