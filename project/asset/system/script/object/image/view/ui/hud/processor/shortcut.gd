extends Node

class_name InputObserver

signal input(event: InputEvent)

func _input(event: InputEvent) -> void:
	input.emit(event)
