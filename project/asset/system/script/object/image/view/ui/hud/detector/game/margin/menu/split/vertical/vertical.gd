extends VSplitContainer

@export var reserve: int = 6
@export var direction: float = 0.5
@export var node_paths: Array[String] = ["", ""]

@onready var instant: Node = $instant
@onready var smooth: Dictionary = {
	"direct": $smooth_direct, "back": $smooth_back
}

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

func _input(event: InputEvent) -> void:
	if smooth.back.listen(event):
		logic.smooth_back_drag(self)
		return
	if smooth.direct.listen(event):
		logic.smooth_direct_drag(self)
		return
	if instant.listen(event):
		logic.instant_drag(self)
