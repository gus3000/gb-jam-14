class_name BagSprite
extends AnimatedSprite2D

@onready var bag: Bag = $".."

var animations: Dictionary[float, String] = {
	.99: "full",
	.6: "60",
	.3: "30",
	0: "empty",
}

func _on_bag_dirt_amount_changed() -> void:
	var ratio: float = bag.dirt / bag.max_dirt
	print("ratio : ", ratio)
	for threshold in animations.keys():
		if ratio >= threshold:
			print("bag in state : ", threshold, " -> ", animations[threshold])
			play(animations[threshold])
			return
		
