extends Button

class_name TopicFooter

@onready var topic: VBoxContainer = get_parent()
@onready var header: Button = topic.get_node("../header")

var _caption: String
var _title: String
var title: String:
	get: return _title
	set(value):
		_title = value
		text = value

func _ready() -> void: _caption = text

func _hide_topic() -> void:
	topic.hide()
	header.grab_focus()

func finish_input(_id: Array) -> void:
	text = _caption

func input_button(buttons: String) -> void:
	text = buttons + " - " + tr(title)
