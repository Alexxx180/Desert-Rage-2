extends HSplitContainer

signal hide_node()
signal show_node()

@export var reserve: int = 6

@export var direction: float = 0.5
@export var node_paths: Array[String] = ["", ""]

var ui_nodes: Array[Control] = []
var previous: bool = false
var operation: Callable

func bigger(a: float, b: float) -> bool: return a > b
func lesser(a: float, b: float) -> bool: return a < b

func _ready() -> void:
	for path in node_paths:
		ui_nodes.append(get_node(path))
	operation = bigger if direction < 0.0 else lesser

func get_proportion() -> float:
	return get_window().size.x * direction

func hide_nodes() -> void:
	for node in ui_nodes:
		if "hides" in node: node.hides()
		else: node.hide()

func show_nodes() -> void:
	for node in ui_nodes:
		if "shows" in node: node.shows()
		else: node.show()

func on_drag_end() -> void:
	# print("CURRENT: ", split_offset + reserve, "WIND: ", get_proportion())
	var current: bool = operation.call(split_offset + reserve, get_proportion())
	if current: hide_nodes()
	elif previous: show_nodes()
	previous = current
