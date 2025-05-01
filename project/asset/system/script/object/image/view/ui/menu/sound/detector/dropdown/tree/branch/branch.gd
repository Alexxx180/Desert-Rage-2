extends HBoxContainer

@onready var content: BoxContainer = $content

var caption: String:
	set(value):
		content.caption = value

func connect_mix(ost: Dictionary) -> void:
	content.head.mix.safe_connect(ost)
