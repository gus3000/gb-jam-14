extends Node

const KeyObjectType := KeyObject.KeyObjectType

func _on_player_obtain_key_object(object_type: KeyObjectType) -> void:
	print("bag received key object")
	pass
