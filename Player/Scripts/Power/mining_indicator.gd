class_name MiningIndicator
extends AnimatedSprite2D

func start_mining(_block: Block):
	play("blinking")
	pass

func stop_mining(_block: Block):
	play("default")
	pass
