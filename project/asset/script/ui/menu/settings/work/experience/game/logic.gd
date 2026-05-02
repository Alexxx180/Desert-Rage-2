extends Node

var t: Node

var genre: bool = false
var screen: bool: set = set_screen

func _screen(value: bool, w) -> DisplayServer.WindowMode:
	return w.WindowMode.WINDOW_MODE_WINDOWED if value else w.WindowMode.WINDOW_MODE_FULLSCREEN

func set_screen(value: bool) -> void:
	DisplayServer.window_set_mode(_screen(value, DisplayServer))
