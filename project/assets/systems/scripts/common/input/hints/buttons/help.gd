extends Button

var caption: String = ""
@onready var hotkey: Control = $hotkey

func _ready() -> void:
	caption = text
	set_button_text()

func set_button_text():
	text = caption % hotkey.get_text()

func _input(_event: InputEvent):
	set_button_text()
