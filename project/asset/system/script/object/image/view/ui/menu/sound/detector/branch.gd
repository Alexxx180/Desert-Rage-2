extends Button

@onready var short: Control = $caption/short
@onready var description: Label = $caption/margin/description

var pad: Control
var content: Control

func _ready() -> void:
	var title: Control = get_node("../../..")
	description.text = title.name
	pad = title.get_node("pad")
	content = get_node("../../body")

func _toggled(toggled_on: bool) -> void:
	# short.visible = toggled_on
	pad.visible = toggled_on
	content.visible = toggled_on
