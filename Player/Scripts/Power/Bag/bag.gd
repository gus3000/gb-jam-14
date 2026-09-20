class_name Bag
extends Node2D

const KeyObjectType := KeyObject.KeyObjectType

signal dirt_amount_changed(amount: int)

@export var power_level: int = 0
@onready var opening: Node2D = $Opening

var max_power_level: int = 6

var dirt: int = 0:
	set(value):
		var diff = value - dirt
		dirt = value
		dirt_amount_changed.emit(diff)
var objects: Dictionary[KeyObjectType, int]

var max_dirt: int:
	get: match (power_level):
		0: return 0
		1: return 5_000
		2: return 15_000
		3: return 40_000
		4: return 80_000
		5: return 200_000
		_: return 10_000_000 #TODO faire grossir celui-là comme le lv5, et le faire clignoter que au max

func _ready() -> void:
	for object_type in KeyObjectType.values():
		objects[object_type] = 0
	pass

func _on_player_obtain_key_object(object_type: KeyObjectType) -> void:
	print("bag received key object")
	objects[object_type] = 1
	if object_type == KeyObjectType.BAG and power_level == 0:
		power_level = 1
	pass


func add_dirt(amount: int):
	amount = clamp(amount, 0, max_dirt - dirt)
	dirt += amount
# print("dirt in bag : %s/%s" % [dirt, max_dirt])

func extract_dirt(amount: int) -> int:
	if amount > dirt:
		amount = dirt
	dirt -= amount
	return amount

func _on_mining_core_block_mined(block: Block) -> void:
	add_dirt(block.toughness)

func has_key_object(object_type: KeyObjectType) -> bool:
	return object_type in objects.keys() and objects[object_type] > 0
