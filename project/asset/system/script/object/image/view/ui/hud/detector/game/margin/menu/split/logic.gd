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

func positive_toggle(a: float, b: float, nodes: Array) -> void:
	if a >= b: show(nodes)
	else: hide(nodes)

func negative_toggle(a: float, b: float, nodes: Array) -> void:
	if a <= b: show(nodes)
	else: hide(nodes)

func drag_feedback(direction: float, proportion: float, next_offset: float, nodes: Array) -> void:
	if direction < 0:
		negative_toggle(next_offset, proportion, nodes)
	else:
		positive_toggle(next_offset, proportion, nodes)

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
