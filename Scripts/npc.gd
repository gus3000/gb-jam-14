class_name Npc
extends Area2D

@onready var prompt: Sprite2D = $Prompt

var dialog : Array[String] = [
	"Captain!",
	"The key is gone"
]

var base_height := -24.0
var frequency := 8.0

func _physics_process(_delta: float) -> void:
	if prompt.visible:
		prompt.position.y = base_height + sin(frequency * Time.get_unix_time_from_system())
	
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		prompt.show()


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		prompt.hide()
