extends Node

class_name FocusedItems

var _items: Array[Array] = []
var _space: int = 0
var space: int:
	get: return _space

func _grab_focus(selection: int) -> void:
	_items[_space][selection].grab_focus()

func set_focus(selection: int) -> void:
	_grab_focus(clampi(selection - 1, 0, _items[_space].size() - 1))

func first() -> void: _grab_focus(0)
func last() -> void: _grab_focus(-1)

func set_space(selection: int) -> void:
	_space = clampi(selection, 0, _items.size())

func setup(space: Control) -> void:
	space.get_node("focus").setup_items(self)
