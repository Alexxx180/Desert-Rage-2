extends VSplitContainer

@export var reserve: Array[PackedFloat32Array] = [[-6, -0.5], [-70, -0.5], [-106, -0.5]]
@export var node_paths: Array[Array] = [["../topic/scroll/margin/stack/selection"],
	["ability/controls/markers/combos/margin/stack/ray", "ability/controls/markers/combos/margin/stack/rock"],
	["ability/controls/markers/combos/margin/stack/rock"]]

var ui_nodes: Array[Array] = []
var previous: bool = false

func _ready() -> void:
	for i in range(0, len(node_paths)):
		ui_nodes.append([])
		for path in node_paths[i]:
			ui_nodes[i].append(get_node(path))

func get_proportion(direction: float) -> float:
	return get_window().size.y * direction

func hide_nodes(nodes: Array) -> void:
	for node in nodes:
		if "hides" in node: node.hides()
		else: node.hide()

func show_nodes(nodes: Array) -> void:
	for node in nodes:
		if "shows" in node: node.shows()
		else: node.show()

func dragged_item(reserve: float, dir: float, nodes: Array) -> void:
	var next: float = float(split_offset + reserve)
	print("CURRENT: ", next, "- WIND: ", get_proportion(dir))
	if dir < 0:
		negative_toggle(next, get_proportion(dir), nodes)
	else:
		positive_toggle(next, get_proportion(dir), nodes)
	"""
	var a: float = split_offset + reserve
	var b: float = get_proportion(dir)
	var result: bool = false
	var current: bool = (dir < 0 and a >= b) or (dir >= 0 and a <= b)
	if current:
		hide_nodes(nodes)
	elif previous:
		show_nodes(nodes)
	previous = current
	"""

func positive_toggle(a: float, b: float, nodes: Array) -> void:
	if a >= b: show_nodes(nodes)
	elif a < b: hide_nodes(nodes)

func negative_toggle(a: float, b: float, nodes: Array) -> void:
	if a <= b: show_nodes(nodes)
	elif a > b: hide_nodes(nodes)

# func on_drag_end() -> void:
func on_drag_end() -> void:
	for i in range(0, len(reserve)):
		dragged_item(reserve[i][0], reserve[i][1], ui_nodes[i])
