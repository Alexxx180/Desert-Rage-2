extends Node

var manage: Node

func c(e: InputEvent) -> int: return e.button_index

func add_mouse(event: InputEvent) -> void:
	if event is InputEventMouseMotion: return
	
	if event.pressed:
		manage.mode.input.append(c(event))
		manage.mode.input.enter()
	else:
		manage.mode.input.finish()

func hot(event: InputEvent) -> void: add_mouse(event)
