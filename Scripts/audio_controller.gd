extends Node

const TerrainType := DiggableTileMap.TerrainType

const penta_scale: Array[int] = [0, 3, 5, 7, 10, 12, 15, 17, 19, 22]

@onready var generated: AudioStreamPlayer = $Generated
@onready var mining: AudioStreamPlayer = $Mining
@onready var mining_fail: AudioStreamPlayer = $MiningFail

var base_mining_pitch: float = 0.5
var note_length: float = .3

func _ready() -> void:
	setup_signals.call_deferred()
	generated.stream.buffer_length = note_length


func _process(_delta: float) -> void:
	if Input.is_physical_key_pressed(KEY_KP_0):
		await debug_audio()

func setup_signals():
	GameController.player.mining_core.started_mining.connect(_on_player_started_mining)
	GameController.player.mining_core.block_mined.connect(_on_player_block_mined)

func random_penta_scale_pitch() -> float:
	return 0.5 * pow(2, penta_scale.pick_random() / 12.)

func debug_audio() -> void:
	print("debug audio")
	for i in penta_scale:
		mining.pitch_scale = base_mining_pitch * pow(2, i / 12.)
		mining.play()
		await get_tree().create_timer(note_length).timeout
	pass


func _on_player_started_mining(block: Block) -> void:
	if block.type == TerrainType.BEDROCK:
		mining_fail.play()

func _on_player_block_mined(_block: Block) -> void:
	mining.pitch_scale = random_penta_scale_pitch()
	mining.play()
