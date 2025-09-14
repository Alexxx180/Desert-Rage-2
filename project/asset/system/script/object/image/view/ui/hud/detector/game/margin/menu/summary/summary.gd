extends PanelContainer

@onready var stack: VBoxContainer = $scroll/margin/stack/priority
@onready var priorities: Array[VBoxContainer] = []

func _ready() -> void:
	for priority in ["pursuit", "self_control", "tenacity"]:
		priorities.append(stack.get_node(priority))

func set_priorities(summary: Dictionary) -> void:
	for i in range(0, len(priorities)):
		priorities[i].set_priority(i, summary)

func update_exp(xp: Vector2i, base_xp: int) -> void:
	for priority in priorities:
		priority.update_exp(xp.x, xp.y)
