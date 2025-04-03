extends HBoxContainer

@onready var content: BoxContainer = $content

var caption: String:
	set(value):
		content.caption = value

func set_metadata(mix: bool) -> void:
	content.set_metadata(mix)
