extends Node

var player: Player
var terrain: DiggableTileMap
var ui: Ui

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	terrain = get_tree().get_first_node_in_group("terrain")
	ui = get_tree().get_first_node_in_group("ui")
	assert(is_instance_of(GameController.player, Player), "player is not of Player type or is unavailable")

func _process(delta: float) -> void:
	pass

func earthquake()->void:
	ui.queue_string("boom !")
	pass