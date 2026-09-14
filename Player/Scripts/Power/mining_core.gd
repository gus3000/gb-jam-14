class_name MiningCore
extends AbilityCore

signal started_mining
signal block_mined(block: Block)
signal stopped_mining

@export var debug_point: AnimatedSprite2D

@onready var mining_indicator:MiningIndicator = $MiningIndicator

var started_mining_timestamp: int = 0  #ms
var mined_block: Block = null

var is_mining: int:
	get: return started_mining_timestamp != 0
var current_mining_time: int:
	get: return Time.get_ticks_msec() - started_mining_timestamp

func handle_mining(powering: bool) -> void:
	var new_mined_block := block_to_mine()
	if new_mined_block == null:
		return

	if not powering and is_mining:
		stop_mining()

	elif powering and (not is_mining or not new_mined_block.equals(mined_block)):
		if not new_mined_block.equals(mined_block):
			print("mined block ", mined_block)
			print("new mined block", new_mined_block)
		start_mining()
	elif powering:
		continue_mining()

func start_mining() -> void:
	started_mining_timestamp = Time.get_ticks_msec()
	mined_block = block_to_mine()
	print("started mining block ", mined_block)
	started_mining.emit()

func continue_mining() -> void:
	if current_mining_time > mining_time(mined_block, power_level):
		player.looked_at_tilemap.mine_block(mined_block)
		block_mined.emit(mined_block)
		stop_mining()
	pass

func stop_mining() -> void:
	started_mining_timestamp = 0
	mined_block = null
	stopped_mining.emit()


func mining_time(block: Block, _mining_power: int) -> float:
	return block.toughness / _mining_power

func block_to_mine() -> Block:
	# print("trying to mine", Utils.string_from_direction(player.facing_direction))
	# print("thus using raycast", player.looked_at_raycast)
	if not player.looked_at_raycast != null:
		# print("not colliding")
		return null
	var collide_point := player.looked_at_point
	# print("point to mine :", collide_point)
	if collide_point == null:
		return null
	# print("collider to mine :", player.looked_at_raycast.get_collider())

	return player.looked_at_tilemap.get_block_at_point(collide_point)


func highlight_minable_block() -> void:
	var l := player.looked_at_point
	if l == Vector2.ZERO or player.looked_at_tilemap == null:
		debug_point.visible = false
		return

	debug_point.visible = true
	debug_point.global_position = player.looked_at_tilemap.get_block_position(l)

func process(delta:float, powering: bool) -> void:
	highlight_minable_block()
	handle_mining(powering)

func boot() -> void:
	print("boot MINING")
	mining_indicator.show()
	pass

func shutdown() -> void:
	mining_indicator.hide()
