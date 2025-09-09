extends Node

signal resume_input()
signal suspend_input()

var logic: SplitToggleLogic = SplitToggleLogic.new()
var ui_nodes: Array[Array] = []

func setup(navigation: Node) -> void:
	logic.navigation = navigation
	logic.navigation.ui.drag_ended.connect(on_drag_end)
	logic.navigation.ui.drag_started.connect(on_drag_start)
	for paths in navigation.node_paths:
		ui_nodes.append(navigation.get_nodes(paths))

func on_drag_start() -> void:
	suspend_input.emit()

func on_drag_end() -> void:
	for i in range(0, len(logic.navigation.reserve)):
		logic.drag_feedback(logic.is_opened_at(i), ui_nodes[i])
	if not logic.is_opened_last:
		resume_input.emit()
