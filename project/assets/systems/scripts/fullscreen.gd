extends Button

@onready var hotkeys: HBoxContainer = $description/hotkeys
@onready var modes: HBoxContainer = $description/modes

func is_full() -> bool:
	var mode = DisplayServer.window_get_mode()
	return mode == DisplayServer.WINDOW_MODE_FULLSCREEN

func _set_mode(fullscreen: bool) -> void:
	var mode = DisplayServer.WINDOW_MODE_MAXIMIZED
	if (!fullscreen):
		mode = DisplayServer.WINDOW_MODE_FULLSCREEN
	DisplayServer.window_set_mode(mode)

func _toggle_fullscreen(fullscreen: bool) -> void:
	modes.set_window_mode(fullscreen)
	hotkeys.set_control_hint()
	_set_mode(fullscreen)

func _ready() -> void:
	modes.set_window_mode(is_full())
	hotkeys.set_control_hint()

func _input(_event: InputEvent) -> void:
	hotkeys.set_control_hint()
