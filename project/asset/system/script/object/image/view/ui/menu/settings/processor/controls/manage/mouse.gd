extends Node

var manage: Node

func add_mouse(event: InputEvent) -> void:
	if event is InputEventMouseMotion: return
	
	if event.pressed:
		manage.mode.input.append(event.button_index)
		manage.mode.input.enter()
	else:
		manage.mode.input.finish()

func hot(event: InputEvent) -> void: add_mouse(event)
