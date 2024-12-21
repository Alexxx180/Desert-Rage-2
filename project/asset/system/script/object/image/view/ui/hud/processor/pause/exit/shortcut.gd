extends Node

signal pressed()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("fire"):
		pressed.emit()
