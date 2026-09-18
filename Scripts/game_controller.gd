extends Node

const ADDED_SCENE_POSITION: Vector2i = Vector2i(50, 50)

enum LoadableSceneEnum {SHIP_INTERIOR}

class LoadableScene:
	var packed_scene: PackedScene
	var camera_position: Vector2
	var player_scale: float
	var return_point: Vector2
	var instance: AbstractLoadableScene

	func _init(_packed_scene: PackedScene, _camera_position: Vector2, _player_scale=1.):
		packed_scene = _packed_scene
		camera_position = _camera_position
		player_scale = _player_scale


signal enter_fixed_scene
signal leave_fixed_scene
signal world_shuffle(intensity: float)
signal gold_changed(new_amount: int)

@onready var root: Node = $".."

var loadable_scenes: Dictionary[LoadableSceneEnum, LoadableScene]

# var ship_interior_scene: PackedScene = preload("res://Scenes/ship_interior.tscn")
# var ship_interior_instance: Node
# var ship_interior_return_point: Vector2

var camera: CameraRig
var main_scene: Node
var player: Player
var terrain: DiggableTileMap
var ui: Ui
var world: Node2D

var player_start_position: Vector2

var is_debugging: bool = false

func _ready() -> void:
	camera = get_tree().get_first_node_in_group("camera")
	main_scene = get_tree().get_first_node_in_group("main_scene")
	player = get_tree().get_first_node_in_group("player")
	terrain = get_tree().get_first_node_in_group("terrain")
	ui = get_tree().get_first_node_in_group("ui")
	world = get_tree().get_first_node_in_group("world")
	assert(is_instance_of(GameController.player, Player), "player is not of Player type or is unavailable")

	enter_fixed_scene.connect(camera._on_game_controller_enter_fixed_scene)
	leave_fixed_scene.connect(camera._on_game_controller_leave_fixed_scene)

	loadable_scenes = {
		LoadableSceneEnum.SHIP_INTERIOR: LoadableScene.new(
				preload("res://Scenes/ship_interior.tscn"),
				Vector2(0, -50),
				2,
		)
	}
	player_start_position = player.position

func _process(_delta: float) -> void:
	if not OS.is_debug_build():
		return
	if Input.is_physical_key_pressed(KEY_KP_1) and not is_debugging:
		await debug()
	if Input.is_action_just_pressed("debug_increase_mining"):
		player.mining_core.power_level += 1
		GameController.ui.queue_string("Mining increased\nto %s" % player.mining_core.power_level, 1)
	if Input.is_action_just_pressed("debug_increase_bag"):
		player.bag.add_dirt(ceili(player.bag.max_dirt * 0.1))
	if Input.is_action_just_pressed("cheat"):
		player.unlock_cheat()

func debug() -> void:
	is_debugging = true
	earthquake()
	await get_tree().create_timer(1).timeout
	is_debugging = false

func enter_ship() -> void:
	load_scene_additive(LoadableSceneEnum.SHIP_INTERIOR)
	pass

func leave_ship() -> void:
	print("gc leave ship")
	unload_scene_additive(LoadableSceneEnum.SHIP_INTERIOR)

# We want to keep the overworld loaded at all times, so we use this custom function
func load_scene_additive(scene: LoadableSceneEnum) -> void:
	var loadable_scene := loadable_scenes[scene]
	var scene_to_load: PackedScene = loadable_scene.packed_scene

	assert(scene_to_load != null)

	var instance: Node = scene_to_load.instantiate()
	loadable_scene.instance = instance
	loadable_scene.return_point = player.position
	main_scene.remove_child.call_deferred(world)
	main_scene.add_child.call_deferred(instance)

	player.position = Vector2.ZERO
	player.scale = Vector2.ONE * loadable_scene.player_scale
	camera.position = loadable_scene.camera_position
	enter_fixed_scene.emit()
	instance.on_load.call_deferred()
	pass

func unload_scene_additive(scene: LoadableSceneEnum):
	var loadable_scene := loadable_scenes[scene]
	var scene_node: Node = loadable_scene.instance
	var return_point: Vector2 = loadable_scene.return_point

	assert(scene_node != null)
	assert(return_point != null)

	scene_node.on_unload()
	main_scene.remove_child.call_deferred(scene_node)
	main_scene.add_child.call_deferred(world)
	player.position = return_point
	player.scale = Vector2.ONE
	camera.position = return_point
	leave_fixed_scene.emit()


func earthquake(intensity: float=-1) -> void:
	world_shuffle.emit(intensity)
	pass

func teleport_to_start() -> void:
	# TODO add transition
	ui.queue_string("Teleported to start")
	ui.queue_string("Hopefully there\nwill be a\nnice animation\nin the future")
	player.position = player_start_position
	player.velocity = Vector2.UP * 50

func player_exited_world() -> void:
	print("exited world")
	teleport_to_start()

func toggle_pause(should_pause: bool) -> void:
	get_tree().paused = should_pause

func pause() -> void:
	toggle_pause(true)

func unpause() -> void:
	toggle_pause(false)

func is_paused() -> bool:
	return get_tree().paused

func hide_game() -> void:
	main_scene.hide()
	ui.ui_hide()
	pass

func show_game() -> void:
	main_scene.show()
	ui.ui_show()
	camera.make_current()
	pass
