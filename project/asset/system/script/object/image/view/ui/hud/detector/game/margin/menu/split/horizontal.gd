extends HSplitContainer

@export var reserve: int = 6
@export var direction: float = 0.5
@export var node_paths: Array[String] = ["", ""]
@onready var navigation: Node = $navigation

var logic: SplitToggleLogic = SplitToggleLogic.new()
var ui_nodes: Array[Control] = []
var proportion: float:
	get: return get_window().size.x * direction

func _ready() -> void:
	for path in node_paths:
		ui_nodes.append(get_node(path))

func on_drag_end() -> void:
	var next: float = float(split_offset + reserve)
	logic.drag_feedback(direction, proportion, next, ui_nodes)
