extends Node2D

const Message := Ui.Message
const KeyObjectType := KeyObject.KeyObjectType

@onready var things_to_say_start: Array[Message] = [
	Message.new("Hey Captain !", 1),
	Message.new("I had big plans\nbut it seems\nthey've\n\"fallen\"\n short.", 5),
	Message.new("Talk to me later\nif you find\nyour stuff.", 3)
]

@onready var things_to_say_shovel: Array[Message] = [
	Message.new("Nice find !", 1),
	Message.new("You can DIG\nthrough the dirt\nwith the\nB button !", 2),
	Message.new("On a keyboard\nit's the\nX or K\nkeys", 2),
	Message.new("What do\nyou mean\n\"What's a\nB button ?\"", 3),
	Message.new("Oh, and see\nif you can't\nfind the\nSHIP's KEY !", 4),
	Message.new("We can't\nfix the ship\nif it's locked.", 4),
]

@onready var things_to_say_ship_key: Array[Message] = [
	Message.new("You have the\n SHIP's KEY !", 1),
	Message.new("Let's get\ninside !", 1),
]

@onready var things_to_say_jetpack: Array[Message] = [
	Message.new("Did you feel\nthe rumble ?", 1),
	Message.new("When the SHIP\npowered on,\nthe earth started\nSHAKING !", 3),
	Message.new("I was a bit\nscared,\nto be honest.", 2),
	Message.new("The moles look\nhappy about it,\nthough.", 2),
	Message.new("Hey, you found\nyour JETPACK !", 2),
	Message.new("Could you grab\nthe BAG\nabove me ?", 2),
	Message.new("It tried to\njump but it's\ntoo high.", 2),
	Message.new("Also I can't\njump.", 1),
]

@onready var things_to_say_bag: Array[Message] = [
	Message.new("You found your\nBAG !", 1),
	Message.new("You can\nprobably\nstore dirt\nin it.", 2),
	Message.new("The big guys\nsaid the earth\nis rich in\nGOLD here.", 3),
	Message.new("We have a machine\nin the SHIP\nto filter the\ndirt.", 4),
	Message.new("Go to the\nSHIP when your\nbag is full.", 3),
]

@onready var things_to_say_gold: Array[Message] = [
	Message.new("Shiny GOLD !", 1),
	Message.new("Now that the\nSHIP is kind-of\nworking, you can\nUPGRADE\nyour gear !", 3),
	Message.new("We'll need\na LOT more GOLD\nto fully fix\nthe SHIP.", 3),
	Message.new("So get DIGGING,\n boss !", 1),
	Message.new("Me ? I...\nI'll stay here\nto keep the\nmoles at bay.", 3),
	Message.new("Ferocious\ncritters,\nthese things.", 2),
]

@onready var things_to_say_ship_fixable: Array[Message] = [
	Message.new("Wow, that's\nsome GOOD\ngear you have\nhere.", 3),
	Message.new("With that,\nwe can definitely\ngather enough\nGOLD !", 3),
	Message.new("Sorry, I mean\nYOU can.", 1),
	Message.new("I have to\nstay here,\nyou know.", 2),
	Message.new("The MOLES.", 1),
	Message.new("I'm starting\nto like them.", 1),
	Message.new("I wonder how\nthey'll fare\nonce we're gone ?", 3)
]

@onready var things_to_say_enough_gold_to_leave: Array[Message] = [
	Message.new("WOW !", 1),
	Message.new("You have enough\nGOLD to fix\nthe SHIP !", 3),
	Message.new("That's amazing !", 1),
	Message.new("We can go\nHOME !", 1),
	Message.new("...", 1),
	Message.new("I'm gonna miss\nthe little\ncritters.", 2),
	Message.new("Do we really\nhave to go ?", 3),
]


func _on_sign_interact() -> void:
	var thing_to_say: Message = cycle()
	GameController.ui.queue_message(thing_to_say)

func cycle() -> Message:
	var things_to_say: Array[Message] = things_to_say_start
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

	var message = things_to_say.pop_front()
	things_to_say.push_back(message)
	return message
