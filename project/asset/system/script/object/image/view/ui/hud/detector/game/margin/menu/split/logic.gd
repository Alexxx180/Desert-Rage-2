extends RefCounted

class_name SplitToggleLogic

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
