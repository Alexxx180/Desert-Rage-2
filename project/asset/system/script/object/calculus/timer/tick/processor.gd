extends Node

signal play(delta: float)

func _physics_process(delta: float):
	play.emit(delta)
