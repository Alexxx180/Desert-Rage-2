extends PanelContainer

@onready var stack: VBoxContainer = $scroll/margin/stack/priority
@onready var passive: VBoxContainer = $scroll/margin/stack/priority/passive
@onready var priorities: Array[Button] = []

var selected: Control
var description: Dictionary = {}

func connect_description(priority: Button) -> void:
	var hint: HFlowContainer = description[priority.name]
	priority.focus_entered.connect(func(): selected.hide(); hint.show())
	priority.focus_exited.connect(func(): hint.hide(); selected.show())
	priority.mouse_entered.connect(func(): selected.hide(); hint.show())
	priority.mouse_exited.connect(func(): hint.hide(); selected.show())

func _ready() -> void:
	for caption in ["pursuit", "self_control", "tenacity"]:
		var priority: Button = stack.get_node(caption)
		description[priority.name] = passive.get_node(NodePath(priority.name))
		priorities.append(priority)
		connect_description(priority)
	selected = description["pursuit"]

func connect_priority_select(summary: Dictionary) -> void:
	for button in priorities:
		button.connect_selection(self, summary)

func set_priorities(summary: Dictionary) -> void:
	for i in range(0, len(priorities)):
		priorities[i].set_priority(i, summary)
	selected.show()

func update_exp(xp: Vector2i, base_xp: int) -> void:
	for priority in priorities:
		priority.update_exp(xp.x, xp.y)
