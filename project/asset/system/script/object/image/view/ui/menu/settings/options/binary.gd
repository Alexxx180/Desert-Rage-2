extends Button

class_name BinaryChoice

@onready var status: Label = $margin/status

var _caption: Dictionary = { false: "Off", true: "On" }
var _choice: bool = false
var selected: String:
	get: return _caption[_choice]

func sync_caption() -> void:
	status.text = selected

func change_choice() -> void:
	_choice = !_choice
	sync_caption()
