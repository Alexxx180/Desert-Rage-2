extends Node

var logic: SplitToggleLogic = SplitToggleLogic.new()
var ui_nodes: Array[Array] = []

func setup(navigation: Node) -> void:
	logic.navigation = navigation
	logic.navigation.ui.drag_ended.connect(on_drag_end)
	for paths in navigation.node_paths:
		ui_nodes.append(navigation.get_nodes(paths))

func on_drag_end() -> void:
	var n: Node = logic.navigation
	for i in range(0, len(n.reserve)):
		var next: float = float(n.reserve[i] + n.ui.split_offset)
		logic.drag_feedback(n.direction, n.proportion, next, ui_nodes[i])
