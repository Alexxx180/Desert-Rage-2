extends HBoxContainer

@onready var content: VBoxContainer = $content

var caption: String:
	set(value):
		content.head.caption = value
