extends BinaryChoice

var _mode: Dictionary = {
	false: DisplayServer.WINDOW_MODE_WINDOWED,
	true: DisplayServer.WINDOW_MODE_FULLSCREEN
}

func _ready() -> void:
	_caption[false] = "Window"
	_caption[true] = "Fullscreen"
	_choice = DisplayServer.window_get_mode() == _mode[true]
	sync_caption()

func set_fullscreen() -> void:
	DisplayServer.window_set_mode(_mode[_choice])

func toggle() -> void:
	change_choice()
	set_fullscreen()
