extends RefCounted

class_name SplitToggleLogic

var invariant: bool = false

const SMOOTH_MOVE: int = 3

func hide(nodes: Array) -> void:
	for node in nodes:
		if "hides" in node: node.hides()
		else: node.hide()

func show(nodes: Array) -> void:
	for node in nodes:
		if "shows" in node: node.shows()
		else: node.show()

func open_condition(direction: float) -> Callable:
	return (func(a, b): return a <= b) if direction < 0 else (func(a, b): return a >= b)

func is_opened(direction: float, a: float, b: float) -> bool:
	return open_condition(direction).call(a, b)

func drag_feedback(direction: float, proportion: float, next_offset: float, nodes: Array) -> void:
	if is_opened(direction, next_offset, proportion): show(nodes)
	else: hide(nodes)

func open_menu(container: SplitContainer, next: int) -> void:
	container.split_offset = next
	container.on_drag_end()

func _get_move(a: int, b: int, dir: float) -> float:
	return SMOOTH_MOVE * (a if dir < 0 else b)

func out_screen_drag(condition: bool, container: SplitContainer, offset: float, portion: float) -> void:
	if condition:
		open_menu(container, portion)
	else:
		open_menu(container, offset)

func smooth_direct_drag(container: SplitContainer) -> void:
	var move: float = _get_move(1, -1, container.direction)
	var offset: float = container.split_offset
	var portion: float = container.proportion
	if move < 0:
		out_screen_drag(offset > portion, container, offset + move, portion)
	else:
		out_screen_drag(offset < portion, container, offset + move, portion)

func smooth_back_drag(container: SplitContainer) -> void:
	var move: float = _get_move(-1, 1, container.direction)
	open_menu(container, container.split_offset + move)

func instant_drag(container: SplitContainer) -> void:
	invariant = !invariant
	open_menu(container, 0 if invariant else container.proportion)
	focus_element(container)

func focus_element(c: SplitContainer) -> void:
	var nodes: Array = c.focus_nodes
	if nodes.size() > 1 and is_opened(c.direction, c.split_offset, c.proportion):
		nodes[1].grab_focus()
	else:
		nodes[0].grab_focus()
