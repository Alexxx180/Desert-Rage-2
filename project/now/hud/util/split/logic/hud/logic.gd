extends RefCounted

class_name SplitToggleLogic

var toggled: bool = false
var focus: Control
var navigation: Node
var is_opened_last: bool:
	get: return is_opened_at(-1)
var is_opened_first: bool:
	get: return is_opened_at(0)

enum { STRAIGHT = 0, BACKWARD = 1, MOVE = 3 }

func hide(nodes: Array) -> void: toggle(nodes, "hide")
func show(nodes: Array) -> void: toggle(nodes, "show")
func toggle(nodes: Array, prop: String) -> void:
	for node in nodes:
		var next: String = prop + "s"
		node.get(next if next in node else prop).call()

func open_condition(direction: float) -> Callable:
	return (func(a, b): return a > b) if direction < 0 else (func(a, b): return a < b)

func is_opened_at(item: int) -> bool:
	var n: Node = navigation
	var offset: float = float(n.reserve[item] + n.ui.split_offset)
	# print("OFFSET: ", offset, (" >" if n.direction < 0 else " <"), " PORTION: ", n.proportion)
	return open_condition(n.direction).call(offset, n.proportion)

func drag_feedback(opened: bool, nodes: Array) -> void:
	if opened: hide(nodes)
	else: show(nodes)

func open_menu(next: int) -> void:
	navigation.ui.split_offset = next
	navigation.hud.on_drag_end()

func _get_move(a: int, b: int, dir: float) -> float:
	return MOVE * (a if dir < 0 else b)

func out_screen_drag(condition: bool, offset: float, portion: float) -> void:
	open_menu(int(portion if condition else offset))

func straight_drag() -> void:
	var move: float = _get_move(1, -1, navigation.direction)
	var offset: float = navigation.ui.split_offset + move
	var portion: float = navigation.proportion
	out_screen_drag(offset > portion if move < 0 else offset < portion, offset, portion)
	navigation.hud.delay_feedback()

func backward_drag() -> void:
	var move: float = _get_move(-1, 1, navigation.direction)
	open_menu(navigation.ui.split_offset + move)
	navigation.hud.delay_feedback()

func set_effect(offset: int, focused: int) -> void:
	open_menu(offset)
	_set_focus(focused)

func instant_drag() -> void:
	toggled = !toggled
	if toggled: set_effect(0, STRAIGHT)
	else: set_effect(navigation.proportion, BACKWARD)

func _set_focus(no: int) -> void:
	match no:
		0: focus.grab_focus()

func focus_backward() -> void:
	if not is_opened_first: _set_focus(BACKWARD)

func focus_straight() -> void:
	if is_opened_last: _set_focus(STRAIGHT)
