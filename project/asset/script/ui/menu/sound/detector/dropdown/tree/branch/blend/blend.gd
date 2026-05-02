extends HBoxContainer

@onready var content: BoxContainer = $content

var caption: String:
	set(value): content.caption = value

func positioning(right: bool) -> void:
	if right:
		var pad: ColorRect = $pad
		pad.color = Color("85b0f7")

#func set_metadata(mix: int) -> void:
#	content.set_metadata(mix)

func connect_mix(ost: Dictionary) -> void:
	content.safe_connect(ost)
