class_name BagSprite
extends AnimatedSprite2D

@onready var bag: Bag = $".."

var animations: Dictionary[float, String] = {
	.99: "full",
	.6: "60",
	.3: "30",
	0: "empty",
}

func _process(_delta: float) -> void:
	if bag.power_level == 0:
		hide()
	else:
		show()
	pass


func _on_bag_dirt_amount_changed() -> void:
	if bag.power_level == 0:
		return
	var ratio: float = (1.0)*bag.dirt / bag.max_dirt
	# print("ratio : ", ratio)
	for threshold in animations.keys():
		if ratio >= threshold:
			# print("bag in state : ", threshold, " -> ", animations[threshold])
			play(animations[threshold])
			return
		
