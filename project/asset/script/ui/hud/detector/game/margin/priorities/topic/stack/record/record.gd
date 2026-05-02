extends VBoxContainer

@onready var ranking: HFlowContainer = $ranking
@onready var priorities: Array[Button] = ranking.priority.selection.priorities

var selected: int = 0

func _ready() -> void:
	ranking.description.connect_priorities(self)

func connect_priority_select(level: Node, group: Node2D) -> void:
	for button in priorities:
		button.connect_selection(self, level.summary, group.deploy)
	
	group.deploy.select_hero.connect(func(_l):
		ranking.priority.growth.heroes.select_hero(group.deploy.party)
		var hero: String = group.deploy.party.leader.name
		for priority in priorities:
			if priority.priority_no == level.summary.hero[hero].at:
				priority.select()
			else:
				priority.unselect()
			priority.set_hero_priority(priority.priority_no, level.summary, hero)
	)

func set_priorities(level: Node, _stats: Dictionary, group: Node2D) -> void:
	for i in range(0, len(priorities)):
		var hero: String = group.deploy.party.leader.name
		priorities[i].set_hero_priority(i, level.summary, hero)
	# _show(selected)

func update_exp(xp: Vector2i, _base_xp: int) -> void:
	for priority in priorities:
		priority.update_exp(xp.x, xp.y)
