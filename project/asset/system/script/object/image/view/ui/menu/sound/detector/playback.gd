extends Label

var _placeholder: String

func _ready() -> void:
	_placeholder = text

func reset() -> void:
	text = _placeholder
