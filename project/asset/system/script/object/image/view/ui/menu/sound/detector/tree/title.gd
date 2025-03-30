extends HBoxContainer

@onready var named: Button = $named

var caption: String:
	set(value):
		named.caption = value
