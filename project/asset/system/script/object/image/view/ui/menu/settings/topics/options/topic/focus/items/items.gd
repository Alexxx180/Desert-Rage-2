extends Node

class_name FocusedItems

var grabbed: Array[HSlider] = []
var _items: Array[Array] = []
var _focus: Node
var _space: int = 0
var space: int:
	get: return _space

"""
func all_released() -> bool:
	var released: bool = true
	for slider in _grabbed:
		released = released and slider.released
	return released
"""

func _grab_focus(selection: int) -> void:
	_items[_space][selection].grab_focus()

func set_focus(selection: int) -> void:
	_grab_focus(clampi(selection - 1, 0, _items[_space].size() - 1))

func first() -> void: _grab_focus(0)
func last() -> void: _grab_focus(-1)

func set_space(selection: int, _system: int) -> void:
	_space = clampi(selection - 1, 0, _items.size() - 1)
	first()

func setup(game: Control) -> void:
	_focus = game.get_node("focus")
	_focus.setup_items(self)
	_focus.timing.select.connect(set_focus)

func set_transition(hud: CanvasLayer, topic: Control) -> void:
	hud.visibility_changed.connect(func():
		Processors.turn(_focus, hud.visible and topic.visible)
	)
	topic.visibility_changed.connect(func():
		Processors.turn(_focus, hud.visible and topic.visible)
	)
	for slider in grabbed:
		slider.hold_focus.connect(func(status):
			Processors.turn(_focus, status and hud.visible and topic.visible)
		)
