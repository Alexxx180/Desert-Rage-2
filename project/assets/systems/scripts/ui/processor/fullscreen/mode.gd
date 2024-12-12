extends Node

func is_full() -> bool:
	var mode = DisplayServer.window_get_mode()
	return mode == DisplayServer.WINDOW_MODE_FULLSCREEN

func toggle(fullscreen: bool) -> void:
	var mode = DisplayServer.WINDOW_MODE_MAXIMIZED
	if (fullscreen):
		mode = DisplayServer.WINDOW_MODE_FULLSCREEN
	DisplayServer.window_set_mode(mode)
