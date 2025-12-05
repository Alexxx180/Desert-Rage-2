extends VBoxContainer

@onready var priorities: Array[Button] = []
@onready var ranking: HFlowContainer = $ranking

func connect_priority_select(summary: Dictionary) -> void:
	for button in priorities:
		button.connect_selection(self, summary)

func set_priorities(level: Node, _stats: Dictionary) -> void:
	for i in range(0, len(priorities)):
		priorities[i].set_priority(i, level.summary)
	# _show(selected)

func update_exp(xp: Vector2i, _base_xp: int) -> void:
	for priority in priorities:
		priority.update_exp(xp.x, xp.y)
