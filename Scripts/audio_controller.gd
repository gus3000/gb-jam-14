extends Node

const TerrainType := DiggableTileMap.TerrainType

# const penta_scale: Array[int] = [0, 3, 5, 7, 10, 12, 15, 17, 19, 22]
const penta_scale: Array[int] = [0, 3, 5]

@onready var music: AudioStreamPlayer = $Music
@onready var generated: AudioStreamPlayer = $Generated
@onready var mining: AudioStreamPlayer = $Mining/Mining
@onready var mining_fail: AudioStreamPlayer = $Mining/MiningFail
@onready var earthquake: AudioStreamPlayer = $Earthquake
@onready var gold_gain: AudioStreamPlayer = $GoldGain
@onready var key_item_gain: AudioStreamPlayer = $KeyItemGain

@onready var jetpack_begin: AudioStreamPlayer = $Jetpack/Begin
@onready var jetpack_extend: AudioStreamPlayer = $Jetpack/Extend
@onready var jetpack_end: AudioStreamPlayer = $Jetpack/End

@onready var sfx: Array[AudioStreamPlayer] = [
	generated,
	mining,
	mining_fail,
	earthquake,
	gold_gain,
	key_item_gain,
	jetpack_begin,
	jetpack_extend,
	jetpack_end,
]

var base_mining_pitch: float = 0.5
var note_length: float = .3
var is_debugging: bool = false

var last_jetpack_started_id: int = 1

var jetpack_extend_timer: Timer = Timer.new()

func _ready() -> void:
	setup_signals.call_deferred()
	generated.stream.buffer_length = note_length


func _process(_delta: float) -> void:
	if OS.is_debug_build() and Input.is_physical_key_pressed(KEY_KP_0) and not is_debugging:
		await debug_audio()

func setup_signals():
	GameController.player.mining_core.started_mining.connect(_on_player_started_mining)
	GameController.player.mining_core.block_mined.connect(_on_player_block_mined)
	GameController.player.gained_gold.connect(_on_player_gained_gold)
	GameController.player.obtain_key_object.connect(_on_player_gained_key_object)
	GameController.player.started_jetpack.connect(_on_player_started_jetpack)
	GameController.player.stopped_jetpack.connect(_on_player_stopped_jetpack)
	GameController.world_shuffle.connect(_on_world_shuffle)

func random_penta_scale_pitch() -> float:
	return pow(2, (penta_scale.pick_random() - 3) / 12.)

func debug_audio() -> void:
	print("debug audio")
	is_debugging = true
	# for i in penta_scale:
	# 	mining.pitch_scale = base_mining_pitch * pow(2, i / 12.)
	# 	mining.play()
	# 	await get_tree().create_timer(note_length).timeout
	await _on_world_shuffle()
	is_debugging = false
	pass

## volume from 0 to 9
func set_volume(volume: int, music_only: bool):
	var db := (volume - 5) * 4 if volume > 0 else -80
	if music_only: 
		music.volume_db = db
	else:
		for player in sfx:
			player.volume_db = db

func _on_player_started_mining(block: Block) -> void:
	if block.type == TerrainType.BEDROCK:
		mining_fail.play()

func _on_player_block_mined(_block: Block) -> void:
	mining.pitch_scale = random_penta_scale_pitch()
	mining.play()

func _on_player_gained_gold() -> void:
	gold_gain.pitch_scale = random_penta_scale_pitch()
	gold_gain.play()

func _on_player_gained_key_object(_object_type: KeyObject.KeyObjectType) -> void:
	# music.stream_paused = true
	music.volume_db -= 8
	await get_tree().create_timer(.3).timeout

	key_item_gain.play()
	await key_item_gain.finished
	await get_tree().create_timer(.5).timeout
	# music.stream_paused = false
	music.volume_db += 8


func _on_player_started_jetpack() -> void:
	print("start jetpack")
	jetpack_begin.play()
	var id: int = last_jetpack_started_id
	await jetpack_begin.finished
	if id != last_jetpack_started_id:
		print("not the same jetpack start")
		return
	jetpack_extend.play()
	pass

func _on_player_stopped_jetpack() -> void:
	print("stop jetpack")
	last_jetpack_started_id += 1

	if jetpack_begin.playing:
		jetpack_begin.stop()
	else:
		jetpack_end.play()
	jetpack_extend.stop()
	pass

func _on_world_shuffle(_intensity: float=-1) -> void:
	# print("audio controller received earthquake")
	earthquake.play()
	for i in range(5):
		await get_tree().create_timer(0.2).timeout
		earthquake.play()
	for i in range(5):
		await get_tree().create_timer(0.1).timeout
		earthquake.play()
	pass
