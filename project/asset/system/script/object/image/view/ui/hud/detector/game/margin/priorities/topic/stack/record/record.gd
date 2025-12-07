extends VBoxContainer

@onready var priorities: Array[Button] = []
@onready var ranking: HFlowContainer = $ranking

func connect_priority_select(level: Node, group: Node2D) -> void:
	for button in priorities:
		button.connect_selection(self, level.summary, group.deploy)
	group.deploy.select_hero.connect(func(_l):
		var hero: String = group.deploy.party.leader.name
		for priority in priorities:
			if priority.priority_no == level.summary.hero[hero].at:
				priority.select()
			else:
				priority.unselect()
			priority.set_hero_priority(priority.priority_no, level.summary)
			priority.set_next_level(priority.priority_no, level.summary)
	)

func set_priorities(level: Node, _stats: Dictionary) -> void:
	for i in range(0, len(priorities)):
		priorities[i].set_priority(i, level.summary)
	# _show(selected)

func update_exp(xp: Vector2i, _base_xp: int) -> void:
	for priority in priorities:
		priority.update_exp(xp.x, xp.y)
