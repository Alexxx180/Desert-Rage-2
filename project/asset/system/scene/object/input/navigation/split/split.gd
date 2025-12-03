extends Node

@export var controls: SplitNavigation
@export_range(Vector2.Axis.AXIS_X, Vector2.Axis.AXIS_Y, 1) var axis: int

@export_group("Offset")
@export var direction: float = -0.5
@export var reserve: Array[float] = [-6]

@export_group("Paths")
@export var node_paths: Array[Array] = [[""]]
@export var focus_paths: Array[String] = ["", ""]

@onready var input: Node = $input
@onready var focus: Node = $focus
@onready var hud: Node = $hud
@onready var ui: SplitContainer = get_parent()

var proportion: float:
	get: return get_window().size[axis] * direction

func set_property(dir: float, res: Array[float], focused: Control, nodes: Array[Array]) -> void:
	direction = dir; reserve = res
	setup(nodes, focused)

func get_nodes(paths: Array) -> Array:
	var nodes: Array = []
	for path in paths: nodes.append(get_node(path))
	return nodes

func setup(nodes: Array[Array], focused: Control) -> void:
	hud.setup(self, nodes)
	focus.setup(self, focused)
	input.set_order()
# func _ready() -> void: setup()
