extends HSplitContainer

const RESERVE: int = 6

@export var direction: int = 1
@export var node_paths: Array[String] = ["", ""]

var ui_nodes: Array[Control] = []
var previous: bool = false

func _ready() -> void:
	for path in node_paths:
		ui_nodes.append(get_node(path))

func on_drag_end() -> void:
	print("CURRENT: ", split_offset, "WIND: ", get_window().size.x / 2.0 * direction)
	var current: bool = split_offset + RESERVE < get_window().size.x / 2.0 * direction
	if current:
		for node in ui_nodes: node.hide()
	elif previous:
		for node in ui_nodes: node.show()
	previous = current
