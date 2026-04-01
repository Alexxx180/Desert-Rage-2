extends Node

@onready var mouse: Node = $mouse
@onready var keyboard: Node = $keyboard

func input(_event: InputEvent) -> void:
	return # TODO FIXME mouse connect
	
	if Input.is_action_pressed("mouse_move"):
		mouse.mouse_input()
	elif not mouse.go_for_target:
		keyboard.set_input()
