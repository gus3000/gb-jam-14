extends Node

const TerrainType := DiggableTileMap.TerrainType


@onready var mining: AudioStreamPlayer = $Mining
@onready var mining_fail: AudioStreamPlayer = $MiningFail

func _ready() -> void:
	call_deferred("setup_signals")
	
func setup_signals():
	GameController.player.mining_core.started_mining.connect(_on_player_started_mining)
	GameController.player.mining_core.block_mined.connect(_on_player_block_mined)


func _on_player_started_mining(block: Block) -> void:
	if block.type == TerrainType.BEDROCK:
		mining_fail.play()

func _on_player_block_mined(_block: Block) -> void:
	mining.play()
