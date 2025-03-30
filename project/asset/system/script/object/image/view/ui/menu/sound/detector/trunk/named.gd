extends Button

@onready var short: Control = $caption/short

var title: Control
var pad: Control
var content: Control

func _ready() -> void:
	title = get_node("../../../..")
	pad = title.get_node("../pad")
	content = title.get_node("body")

func _toggled(toggled_on: bool) -> void:
	# short.set_active(toggled_on)
	pad.visible = toggled_on
	content.visible = toggled_on
