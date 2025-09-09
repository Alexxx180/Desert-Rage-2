extends RefCounted

class_name SplitToggleLogic

var toggled: bool = false
var focus: Array
var navigation: Node

enum { STRAIGHT = 0, BACKWARD = 1, MOVE = 3 }

func toggle(nodes: Array, prop: String, override: Callable, basic: Callable) -> void:
	for node in nodes:
		if prop in node: override.call(node)
		else: basic.call(node)

func hide(nodes: Array) -> void: toggle(nodes, "hides", func(n): n.hides(), func(n): n.hide())
func show(nodes: Array) -> void: toggle(nodes, "shows", func(n): n.shows(), func(n): n.show())

func open_condition(direction: float) -> Callable:
	return (func(a, b): return a <= b) if direction < 0 else (func(a, b): return a >= b)

func drag_feedback(direction: float, proportion: float, offset: float, nodes: Array) -> void:
	print("OFFSET: ", offset, " - PORTION: ", proportion)
	if open_condition(direction).call(offset, proportion): show(nodes)
	else: hide(nodes)

func open_menu(next: int) -> void:
	navigation.ui.split_offset = next
	navigation.hud.on_drag_end()

func _get_move(a: int, b: int, dir: float) -> float:
	return MOVE * (a if dir < 0 else b)

func out_screen_drag(condition: bool, offset: float, portion: float) -> void:
	open_menu(portion if condition else offset)

func straight_drag() -> void:
	var move: float = _get_move(1, -1, navigation.ui.direction)
	var offset: float = navigation.ui.split_offset + move
	var portion: float = navigation.ui.proportion
	out_screen_drag(offset > portion if move < 0 else offset < portion, offset, portion)

func backward_drag() -> void:
	var move: float = _get_move(-1, 1, navigation.ui.direction)
	open_menu(navigation.ui.split_offset + move)

func set_effect(offset: int, focus: int) -> void:
	open_menu(offset)
	_set_focus(focus)

func instant_drag() -> void:
	toggled = !toggled
	if toggled: set_effect(0, STRAIGHT)
	else: set_effect(navigation.ui.proportion, BACKWARD)

func _set_focus(no: int) -> void: focus[no].grab_focus()
func focus_backward() -> void: _set_focus(BACKWARD)
func focus_straight() -> void: _set_focus(STRAIGHT)
