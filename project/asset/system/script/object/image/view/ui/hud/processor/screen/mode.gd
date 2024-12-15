extends Node

func full(): return DisplayServer.WINDOW_MODE_FULLSCREEN

func is_full() -> bool: return DisplayServer.window_get_mode() == full()

func toggle(fullscreen: bool) -> void:
	var mode = DisplayServer.WINDOW_MODE_MAXIMIZED
	if (fullscreen):
		mode = full()
	DisplayServer.window_set_mode(mode)
