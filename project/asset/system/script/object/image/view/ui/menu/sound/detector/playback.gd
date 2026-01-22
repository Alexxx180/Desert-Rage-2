extends RichTextLabel

var _placeholder: String

func _ready() -> void:
	_placeholder = text

func reset() -> void:
	text = _placeholder
