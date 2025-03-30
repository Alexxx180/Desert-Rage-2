extends Button

@onready var short: Control = $caption/short
@onready var description: Label = $caption/margin/description

var _ui_caption: String

var pad: Control
var content: Control

var caption: String:
	set(value):
		_ui_caption = value
		description.text = _ui_caption

func _ready() -> void:
	var title: Control = get_node("../../..")
	pad = title.get_node("pad")
	content = get_node("../../body")

func _toggled(toggled_on: bool) -> void:
	pad.visible = toggled_on
	content.visible = toggled_on
