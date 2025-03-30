extends Button

@onready var short: Control = $caption/short
@onready var description: Label = $caption/margin/description

var _ui_caption: String

var title: Control
var pad: Control
var content: Control

var caption: String:
	set(value):
		_ui_caption = value
		description.text = value

func _ready() -> void:
	title = get_node("../../../..")
	pad = title.get_node("../pad")
	content = title.get_node("body")

func _toggled(toggled_on: bool) -> void:
	# short.set_active(toggled_on)
	pad.visible = toggled_on
	content.visible = toggled_on
