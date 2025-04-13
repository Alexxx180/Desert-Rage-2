extends Node

@onready var head: BoxContainer = $head
@onready var body: BoxContainer = $body

var caption: String:
	set(value):
		head.caption = value

func set_metadata(mix: bool) -> void:
	head.set_metadata(mix)
