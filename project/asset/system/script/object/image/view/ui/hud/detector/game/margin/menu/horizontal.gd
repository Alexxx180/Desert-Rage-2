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
	# operation = bigger if direction < 0.0 else lesser

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

func positive_toggle(a: float, b: float) -> void:
	if a >= b: show_nodes()
	elif a < b: hide_nodes()

func negative_toggle(a: float, b: float) -> void:
	if a <= b: show_nodes()
	elif a > b: hide_nodes()

func on_drag_end() -> void:
	var next: float = float(split_offset + reserve)
	print("CURRENT: ", next, "- WIND: ", get_proportion())
	if direction < 0:
		negative_toggle(next, get_proportion())
	else:
		positive_toggle(next, get_proportion())
