extends Node

signal pressed()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("fire") and event is not InputEventMouseButton:
		pressed.emit()
