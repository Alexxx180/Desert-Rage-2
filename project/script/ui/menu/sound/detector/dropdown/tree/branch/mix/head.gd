extends HBoxContainer

@onready var named: Button = $named
@onready var mix: Button = $mix

var caption: String:
	set(value):
		named.caption = value

func set_metadata(value: bool) -> void:
	mix.set_metadata(value)
