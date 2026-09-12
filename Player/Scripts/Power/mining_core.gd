class_name MiningCore
extends Node

signal started_mining

@export_custom(PROPERTY_HINT_NONE, "suffix:ms") var MINING_COOLDOWN: int = 300
@export var debug_point: Sprite2D

@onready var player: Player = $"../.."

var last_mined_block_timestamp: int = 0


func handle_mining() -> void:
	var now: int = Time.get_ticks_msec()
	if now - last_mined_block_timestamp >= MINING_COOLDOWN:
		last_mined_block_timestamp = now
		mine_block()

func mine_block() -> void:
	print("trying to mine", Utils.string_from_direction(player.facing_direction))
	print("thus using raycast", player.looked_at_raycast)
	if not player.looked_at_raycast != null:
		print("not colliding")
		return
	var collide_point := player.looked_at_point
	print("point to mine :", collide_point)
	if collide_point == null:
		return
	# print("with normal", looked_at_raycast.get_collision_normal())
	# collide_point -= looked_at_raycast.get_collision_normal()
	print("collider to mine :", player.looked_at_raycast.get_collider())

	started_mining.emit()
	player.looked_at_tilemap.mine_block(collide_point)

func highlight_minable_block() -> void:
	var l := player.looked_at_point
	if l == Vector2.ZERO or player.looked_at_tilemap == null:
		debug_point.visible = false
		return
	# print(looked_at_point)
	debug_point.visible = true
	debug_point.global_position = player.looked_at_tilemap.get_block_position(l)
	#endregion
