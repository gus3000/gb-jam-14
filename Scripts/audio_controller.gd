extends Node

const TerrainType := DiggableTileMap.TerrainType
const CutsceneType := Cutscene.CutsceneType

# const penta_scale: Array[int] = [0, 3, 5, 7, 10, 12, 15, 17, 19, 22]
const penta_scale: Array[int] = [0, 3, 5]

@onready var generated: AudioPlayer = $Generated
@onready var mining: AudioPlayer = $Player/Mining/Mining
@onready var earthquake: AudioPlayer = $Earthquake
@onready var gold_gain: AudioPlayer = $Player/GoldGain
@onready var key_item_gain: AudioPlayer = $Player/KeyItemGain
@onready var fail: AudioPlayer = $Fail
@onready var win: AudioPlayer = $Win

@onready var jetpack_begin: AudioPlayer = $Player/Jetpack/Begin
@onready var jetpack_extend: AudioPlayer = $Player/Jetpack/Extend
@onready var jetpack_end: AudioPlayer = $Player/Jetpack/End

@onready var walking: AudioPlayer = $Player/Walking
@onready var jump: AudioPlayer = $Player/Jump

@onready var mole_hit_ground: AudioStreamPlayer = $Mole/HitGround

@onready var main_music: AudioPlayer = $Music/Main
@onready var intro_music: AudioStreamPlayer = $Music/Intro

@onready var music: Array[AudioPlayer] = [
	main_music,
	intro_music
]

@onready var sfx: Array[AudioPlayer] = [
	generated,
	mining,
	fail,
	earthquake,
	gold_gain,
	key_item_gain,
	jetpack_begin,
	jetpack_extend,
	jetpack_end,
]

@onready var cutscenes_music: Dictionary[CutsceneType, AudioStreamPlayer] = {
	CutsceneType.INTRO: $Music/Intro
}

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
	GameController.player.failed.connect(_on_player_failed)
	GameController.player.started_jetpack.connect(_on_player_started_jetpack)
	GameController.player.stopped_jetpack.connect(_on_player_stopped_jetpack)
	GameController.player.started_walking.connect(_on_player_started_walking)
	GameController.player.stopped_walking.connect(_on_player_stopped_walking)
	GameController.player.jumped.connect(_on_player_jumped)
	GameController.world_shuffle.connect(_on_world_shuffle)
	GameController.won.connect(_on_won)
	CutsceneController.cutscene_starts_playing.connect(_on_cutscene_starts_playing)
	CutsceneController.cutscene_stops_playing.connect(_on_cutscene_stops_playing)

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
		for player in music:
			player.change_volume(db)
	else:
		for player in sfx:
			player.change_volume(db)

func _on_player_started_mining(block: Block) -> void:
	if block.type == TerrainType.BEDROCK:
		fail.play()

func _on_player_block_mined(_block: Block) -> void:
	mining.pitch_scale = random_penta_scale_pitch()
	mining.play()

func _on_player_gained_gold() -> void:
	gold_gain.pitch_scale = random_penta_scale_pitch()
	gold_gain.play()

func _on_player_gained_key_object(_object_type: KeyObject.KeyObjectType) -> void:
	# music.stream_paused = true
	main_music.volume_db -= 8
	await get_tree().create_timer(.3).timeout

	key_item_gain.play()
	await key_item_gain.finished
	await get_tree().create_timer(.5).timeout
	# music.stream_paused = false
	main_music.volume_db += 8

func _on_player_failed() -> void:
	fail.play()

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

func _on_player_started_walking() -> void:
	walking.play()
	pass
func _on_player_stopped_walking() -> void:
	walking.stop()
	pass
func _on_player_jumped() -> void:
	jump.play()
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

func _on_won() -> void:
	main_music.stream_paused = true
	win.play()

func _on_mole_hit_ground() -> void:
	mole_hit_ground.play()
	pass

func _on_cutscene_starts_playing(cutscene: CutsceneType) -> void:
	if cutscenes_music.has(cutscene):
		main_music.stream_paused = true
		cutscenes_music[cutscene].play()
	pass

func _on_cutscene_stops_playing(cutscene: CutsceneType) -> void:
	if cutscenes_music.has(cutscene):
		cutscenes_music[cutscene].stop()
		await get_tree().create_timer(1).timeout
		main_music.stream_paused = false
		main_music.seek(0)
	pass
