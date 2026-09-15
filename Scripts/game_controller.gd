extends Node

const ADDED_SCENE_POSITION: Vector2i = Vector2i(50, 50)

enum LoadableSceneEnum {SHIP_INTERIOR}

class LoadableScene:
	var packed_scene: PackedScene
	var camera_position: Vector2
	var return_point: Vector2
	var instance: Node

	func _init(_packed_scene: PackedScene, _camera_position: Vector2):
		packed_scene = _packed_scene
		camera_position = _camera_position


signal enter_fixed_scene
signal leave_fixed_scene

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
				Vector2(0, -50)
		)
	}


func enter_ship() -> void:
	# ui.queue_string("Entered ship")
	load_scene_additive(LoadableSceneEnum.SHIP_INTERIOR)
	pass

# We want to keep the overworld loaded at all times, so we use this custom function
func load_scene_additive(scene: LoadableSceneEnum) -> void:
	var loadable_scene := loadable_scenes[scene]
	var scene_to_load: PackedScene = loadable_scene.packed_scene

	assert(scene_to_load != null)

	var instance: Node = scene_to_load.instantiate()
	main_scene.remove_child(world)
	main_scene.add_child(instance)
	player.position = Vector2.ZERO
	camera.position = loadable_scene.camera_position
	enter_fixed_scene.emit()
	pass

func unload_scene_additive(scene: LoadableSceneEnum):
	var loadable_scene := loadable_scenes[scene]
	var scene_node: Node = loadable_scene.instance
	var return_point: Vector2 = loadable_scene.return_point

	assert(scene_node != null)
	assert(return_point != null)
	main_scene.remove_child(scene_node)
	main_scene.add_child(world)
	player.position = return_point
	camera.position = return_point
	leave_fixed_scene.emit()
	

func earthquake() -> void:
	# ui.queue_string("boom !")
	pass
