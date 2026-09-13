class_name MiningIndicator
extends AnimatedSprite2D

func start_mining():
	print("indicator -> start mining")
	play("blinking")
	pass

func stop_mining():
	print("indicator -> stop mining")
	play("default")
	pass
