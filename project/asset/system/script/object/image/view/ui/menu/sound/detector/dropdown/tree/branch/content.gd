extends VBoxContainer

@onready var head: HBoxContainer = $head
@onready var body: VBoxContainer = $body

var caption: String:
	set(value):
		head.caption = value
