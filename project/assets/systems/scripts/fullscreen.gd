extends Button

var caption: String = ""
@onready var hotkey: Control = $hotkey

func _ready() -> void:
	caption = text
	set_button_text()

func is_fullscreen(mode):
	return mode == DisplayServer.WINDOW_MODE_FULLSCREEN

func set_button_text():
	if is_fullscreen(DisplayServer.window_get_mode()):
		text = caption % [hotkey.get_text(), "Экран 🔳"]
	else:
		text = caption % [hotkey.get_text(), "Окно 🔲"]

func _input(_event: InputEvent):
	set_button_text()

func window(full):
	return (DisplayServer.WINDOW_MODE_MAXIMIZED if (full)
	else DisplayServer.WINDOW_MODE_FULLSCREEN)

func _toggle_fullscreen():
	var full = is_fullscreen(DisplayServer.window_get_mode())
	var mode = window(full)
	DisplayServer.window_set_mode(mode)
	set_button_text()
