extends Node

const TerrainType := DiggableTileMap.TerrainType

# const penta_scale: Array[int] = [0, 3, 5, 7, 10, 12, 15, 17, 19, 22]
const penta_scale: Array[int] = [0, 3, 5]

@onready var generated: AudioStreamPlayer = $Generated
@onready var mining: AudioStreamPlayer = $Mining
@onready var mining_fail: AudioStreamPlayer = $MiningFail
@onready var earthquake: AudioStreamPlayer = $Earthquake

var base_mining_pitch: float = 0.5
var note_length: float = .3
var is_debugging: bool = false

func _ready() -> void:
	generated.stream.buffer_length = note_length


func _process(_delta: float) -> void:
	if OS.is_debug_build() and Input.is_physical_key_pressed(KEY_KP_0) and not is_debugging:
		await debug_audio()


func random_penta_scale_pitch() -> float:
	return pow(2, (penta_scale.pick_random() - 3) / 12.)

func debug_audio() -> void:
	print("debug audio")
	is_debugging = true
	# for i in penta_scale:
	# 	mining.pitch_scale = base_mining_pitch * pow(2, i / 12.)
	# 	mining.play()
	# 	await get_tree().create_timer(note_length).timeout
	await play_world_shuffle()
	is_debugging = false
	pass


func play_player_started_mining(block: Block) -> void:
	if block.type == TerrainType.BEDROCK:
		mining_fail.play()

func play_player_block_mined(_block: Block) -> void:
	mining.pitch_scale = random_penta_scale_pitch()
	mining.play()

func play_world_shuffle(_intensity:float=-1) -> void:
	# print("audio controller received earthquake")
	earthquake.play()
	for i in range(5):
		await get_tree().create_timer(0.2).timeout
		earthquake.play()
	for i in range(5):
		await get_tree().create_timer(0.1).timeout
		earthquake.play()
	pass
