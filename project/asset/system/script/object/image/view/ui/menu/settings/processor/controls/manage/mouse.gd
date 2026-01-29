extends Node

var manage: Node

func add_mouse(event: InputEvent) -> void:
	if event is InputEventMouseMotion: return
	
	if event.pressed:
		manage.next.append(event.button_index)
	else:
		manage.finish(manage.next)

func alternate(event: InputEvent) -> void: add_mouse(event)
