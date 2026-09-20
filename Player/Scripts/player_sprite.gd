class_name PlayerSprite
extends AnimatedSprite2D

const Direction := Utils.Direction

enum PlayerAnimation {
	IDLE,
	WALK,
	JUMP,
	FALL,
	LAND,
	MINE,
}

@onready var bag:Node2D = $"../PowerCore/Bag"

@onready var animations: Dictionary[PlayerAnimation, String] = {
	PlayerAnimation.IDLE: "Idle",
	PlayerAnimation.WALK: "Walk",
	PlayerAnimation.JUMP: "Jump",
	PlayerAnimation.FALL: "Fall",
	PlayerAnimation.LAND: "Land",
	PlayerAnimation.MINE: "Mine",
}

# only left or right here
var last_held_direction: Direction = Direction.RIGHT

func _ready() -> void:
	pass
	# print("sprite frames : ", sprite_frames)


func _process(_delta: float) -> void:		
	pass

func handle_direction_change(new_direction: Direction) -> void:
	if new_direction not in [Direction.LEFT, Direction.RIGHT]:
		return
	if new_direction == last_held_direction:
		return
	last_held_direction = new_direction
	flip()

func flip()->void:
	flip_h = not flip_h
	bag.scale.x = -bag.scale.x

func slot_animation(player_animation: PlayerAnimation, direction: Direction) -> void:
	var anim := animations[player_animation]
	play(anim)
	handle_direction_change(direction)
	pass


func _on_player_movement_just_paused(paused: bool) -> void:
	# print("sprite got that movement just paused ! ", paused)
	if paused:
		pause()
	else:
		play()
