extends Node

signal resume_input()
signal suspend_input()

@onready var timer: Timer = $suspend

var logic: SplitToggleLogic = SplitToggleLogic.new()
var ui_nodes: Array[Array] = []

func _ready() -> void:
	timer.timeout.connect(drag_feedback)

func setup(navigation: Node, nodes_pack: Array) -> void:
	logic.navigation = navigation
	logic.navigation.ui.drag_ended.connect(on_drag_end)
	logic.navigation.ui.drag_started.connect(on_drag_start)
	for nodes in nodes_pack: # navigation.node_paths:
		ui_nodes.append(nodes)#navigation.get_nodes(paths))

func on_drag_start() -> void:
	print("SUSPEND INPUT")
	suspend_input.emit()

func drag_feedback() -> void:
	print("RESUME INPUT")
	resume_input.emit()

func delay_feedback() -> void:
	timer.start()
	on_drag_start()

func on_drag_end() -> void:
	for i in range(0, len(logic.navigation.reserve)):
		logic.drag_feedback(logic.is_opened_at(i), ui_nodes[i])
	#if not logic.is_opened_last:
	drag_feedback()
