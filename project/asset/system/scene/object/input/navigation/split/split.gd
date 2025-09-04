extends Node

@export var focus_paths: Array[String] = ["", ""]
@onready var instant: Node = $instant
@onready var actions: Array[Node] = [$tab_focus, $smooth_direct, $smooth_back, $instant]

var mask: Array[int] = []
var focus_nodes: Array[Control] = []

func _ready() -> void:
	var c: SplitContainer = get_parent()
	var logic: Array[Callable] = [c.logic.focus_element, c.logic.smooth_back_drag,
		c.logic.smooth_direct_drag, c.logic.instant_drag]
	for i in range(0, len(logic)):
		actions[i].feedback.connect(func(): logic[i].call(c))
	for path in focus_paths:
		focus_nodes.append(get_node(path))

func _input(event: InputEvent) -> void:
	for action in actions:
		if action.listen(event):
			return
