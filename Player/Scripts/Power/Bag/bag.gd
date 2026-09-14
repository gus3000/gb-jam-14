class_name Bag
extends AbilityCore

const KeyObjectType := KeyObject.KeyObjectType

signal dirt_amount_changed

@export var dirt_per_power_level: float = 1000  #TODO use array instead

var dirt: float = 0
var objects: Dictionary[KeyObjectType, int] = {

}

var has_ship_key: bool = false  #TODO

var max_dirt: float:
	get: match (power_level):
		0: return 0
		1: return 1500
		2: return 5000
		3: return 10000
		4: return 20000
		5: return 100000
		_: return 1000000000

func _on_player_obtain_key_object(object_type: KeyObjectType) -> void:
	print("bag received key object")
	#TODO
	pass


func add_dirt(amount: float):
	dirt += amount
	dirt = clamp(dirt, 0, max_dirt)
	print("dirt in bag : %s/%s" % [dirt, max_dirt])
	dirt_amount_changed.emit()

func _on_mining_core_block_mined(block: Block) -> void:
	add_dirt(block.toughness)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_increase_bag"):
		add_dirt(100)

func process(delta: float, powering: bool) -> void:
	pass

func boot() -> void:
	pass

func shutdown() -> void:
	pass
