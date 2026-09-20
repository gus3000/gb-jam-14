extends Node2D

const KeyObjectType := KeyObject.KeyObjectType

@onready var things_to_say_start: Array[String] = [
	"Hey Captain !",
	"I had big plans\nbut it seems\nthey've\n\"fallen\"\n short.",
	"Talk to me later\nif you find\nyour stuff.)"
]

@onready var things_to_say_shovel: Array[String] = [
	"Nice find !",
	"You can DIG\nthrough the dirt\by holding\nB button !",
	"On a keyboard\nit's the\nX or K\nkeys",
	"What do\nyou mean\n\"What's a\nB button ?\"",
	"Oh, and see\nif you can't\nfind the\nSHIP's KEY !",
	"We can't\nfix the ship\nif it's locked.",
]

@onready var things_to_say_ship_key: Array[String] = [
	"You have the\n SHIP's KEY !",
	"Let's get\ninside !",
]

@onready var things_to_say_jetpack: Array[String] = [
	"Did you feel\nthe rumble ?",
	"When the SHIP\npowered on,\nthe earth started\nSHAKING !",
	"I was a bit\nscared,\nto be honest.",
	"The moles look\nhappy about it,\nthough.",
	"Hey, you found\nyour JETPACK !",
	"Could you grab\nthe BAG\nabove me ?",
	"It tried to\njump but it's\ntoo high.",
	"Also I can't\njump.",
]

@onready var things_to_say_bag: Array[String] = [
	"You found your\nBAG !",
	"You can\nprobably\nstore dirt\nin it.",
	"The big guys\nsaid the earth\nis rich in\nGOLD here.",
	"We have a machine\nin the SHIP\nto filter the\ndirt.",
	"Go to the\nSHIP when you\nwant to empty\nyour BAG.",
]

@onready var things_to_say_gold: Array[String] = [
	"Shiny GOLD !",
	"Now that the\nSHIP is kind-of\nworking, you can\nUPGRADE\nyour gear !",
	"We'll need\na LOT more GOLD\nto fully fix\nthe SHIP.",
	"So get DIGGING,\n boss !",
	"Me ? I...\nI'll stay here\nto keep the\nmoles at bay.",
	"Ferocious\ncritters,\nthese things.",
]

@onready var things_to_say_ship_fixable: Array[String] = [
	"Wow, that's\nsome GOOD\ngear you have\nhere.",
	"With that,\nwe can definitely\ngather enough\nGOLD !",
	"Sorry, I mean\nYOU can.",
	"I have to\nstay here,\nyou know.",
	"The MOLES.",
	"I'm starting\nto like them.",
	"I wonder how\nthey'll fare\nonce we're gone ?)"
]

@onready var things_to_say_enough_gold_to_leave: Array[String] = [
	"WOW !",
	"You have enough\nGOLD to fix\nthe SHIP !",
	"That's amazing !",
	"We can go\nHOME !",
	"...",
	"I'm gonna miss\nthe little\ncritters.",
	"Do we really\nhave to go ?",
]


func _on_sign_interact() -> void:
	var things_to_say: Array[String] = get_things_to_say()
	for thing in things_to_say:
		GameController.ui.queue_string(thing)

func get_things_to_say() -> Array[String]:
	var things_to_say: Array[String] = things_to_say_start
	if GameController.player.has_key_object(KeyObjectType.SHOVEL):
		things_to_say = things_to_say_shovel
	if GameController.player.has_key_object(KeyObjectType.SHIP_KEY):
		things_to_say = things_to_say_ship_key
	if GameController.player.has_key_object(KeyObjectType.JETPACK):
		things_to_say = things_to_say_jetpack
	if GameController.player.has_key_object(KeyObjectType.BAG):
		things_to_say = things_to_say_bag
	if GameController.player.gold > 0:
		things_to_say = things_to_say_gold
	if GameController.player.can_buy_escape():
		things_to_say = things_to_say_ship_fixable
	if GameController.player.can_buy_escape() and (GameController.player.gold + GameController.player.bag.dirt) > 10_000_000:
		things_to_say = things_to_say_enough_gold_to_leave

	return things_to_say
