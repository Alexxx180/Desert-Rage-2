extends VSplitContainer

@export var reserve: int = 6
@export var direction: float = 0.5
@export var node_paths: Array[String] = ["", ""]
@onready var navigation: Node = $navigation

var logic: SplitToggleLogic = SplitToggleLogic.new()
var ui_nodes: Array[Control] = []
var proportion: float:
	get: return get_window().size.y * direction

func _ready() -> void:
	for path in node_paths:
		ui_nodes.append(get_node(path))

func on_drag_end() -> void:
	var next: float = float(split_offset + reserve)
	logic.drag_feedback(direction, proportion, next, ui_nodes)

func open_menu(next: int) -> void:
	split_offset = next
	on_drag_end()


extends VSplitContainer

var stack: String = "ability/controls/markers/margin/stack/"

@export var reserve: Array[PackedFloat32Array] = [[-6, -0.5], [-70, -0.5], [-106, -0.5]]
@export var node_paths: Array[Array] = [["../topic/scroll/margin/stack/selection"],
	[stack + "ray", stack + "rock"], [stack + "rock"]]
@onready var navigation: Node = $navigation

var logic: SplitToggleLogic = SplitToggleLogic.new()
var ui_nodes: Array[Array] = []
var direction: float:
	get: return reserve[0][1]
var proportion: float:
	get: return get_proportion(direction)

func get_proportion(dir: float) -> float:
	return get_window().size.y * dir

func _ready() -> void:
	for i in range(0, len(node_paths)):
		ui_nodes.append([])
		for path in node_paths[i]:
			ui_nodes[i].append(get_node(path))

func on_drag_end() -> void:
	for i in range(0, len(reserve)):
		var dir: float = reserve[i][1]
		var next: float = float(reserve[i][0] + split_offset)
		logic.drag_feedback(dir, get_proportion(dir), next, ui_nodes[i])



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
