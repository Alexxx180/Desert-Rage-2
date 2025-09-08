extends Node

@export_group("Offset")
@export var direction: float = -0.5
@export var reserve: Array[float] = [-6]

@export_group("Paths")
@export var node_paths: Array[Array] = [[""]]
@export var focus_paths: Array[String] = ["", ""]

@export var controls: SplitNavigation

@onready var input: Node = $input
@onready var focus: Node = $focus
@onready var hud: Node = $hud
@onready var ui: SplitContainer = get_parent()

var proportion: float:
	get: return get_window().size.y * direction

func get_nodes(paths: Array) -> Array:
	var nodes: Array = []
	for path in paths: nodes.append(get_node(path))
	return nodes

func _ready() -> void:
	hud.setup(self)
	focus.setup(self)
	input.set_order()
