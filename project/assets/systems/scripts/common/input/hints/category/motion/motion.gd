extends VBoxContainer

signal show_help_button()

var help: String: get = _get_help
var _help: Array[String] = ["appear", "disappear"]
var _state: int = 1

@onready var animation: AnimationTree = $animation

func show_full_help() -> void:
	animation.set("parameters/help/transition_request", "full")

func _get_help() -> String:
	_state = (_state + 1) % 2
	return _help[_state]

func make_progress(hint: String, act: String) -> void:
	animation.set("parameters/hints/transition_request", hint)
	animation.set("parameters/%s/transition_request" % hint, act)

func toggle_hints() -> void:
	animation.set("parameters/full/transition_request", help)

func done_progress() -> void:
	show_full_help()
	show_help_button.emit()
