extends HBoxContainer

@onready var enter: Button = $enter
@onready var collapse: Button = $collapse

var nodes: Array[Button]

func connect_collapsing(options: Array, t: Node) -> void:
	nodes = []
	for i in options: nodes.push_back(t.of(i))
	collapse.pressed.connect(toggle)

func toggle() -> void:
	var state: bool = !nodes.front().visible
	for b in nodes: b.visible = state # print("B NAME: ", b.name, " - STATE: ", b.visible)
