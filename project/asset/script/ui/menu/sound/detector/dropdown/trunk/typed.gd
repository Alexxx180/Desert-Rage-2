extends Button

@onready var short: Control = $short

var pad: Control
var content: Control

func _ready() -> void:
	var title: Control = get_node("../../..")
	pad = title.get_node("pad")
	content = get_node("../../body")

func _toggled(toggled_on: bool) -> void:
	short.set_active(toggled_on)
	pad.visible = toggled_on
	content.visible = toggled_on
