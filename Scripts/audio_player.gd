class_name AudioPlayer
extends AudioStreamPlayer

@onready var start_db: float = volume_db

func change_volume(db: float) -> void:
	volume_db = start_db + db
	pass
