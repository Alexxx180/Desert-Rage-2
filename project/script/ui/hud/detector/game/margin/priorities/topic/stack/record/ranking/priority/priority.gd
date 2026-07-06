extends VBoxContainer

#@onready var priority: VBoxContainer = $priority
#@onready var description: Label = $description 

@onready var growth: HBoxContainer = $growth

@onready var pursuit: Button = $pursuit
@onready var self_control: Button = $self_control
@onready var tenacity: Button = $tenacity
@onready var select: MakeStats.PRIORITIES = pursuit.priority_no

var priorities: Array[Button]:
	get: return [pursuit, self_control, tenacity]

func _toggle_call(i: Array[int], ui: VBoxContainer) -> Callable:
	return func(): for j in [[i[0], "hide"], [i[1], "show"]]: ui.toggle(j[0], j[1])

func _order(next: int) -> Array: return [["nter", [select, next]], ["xit", [next, select]]]

func connect_priority(priority: Button, ui: VBoxContainer) -> void:
	for method in ["focus", "mouse"]:
		for i in _order(priority.priority_no):
			priority.get("%s_e%s" % [method, i[0]]).connect(_toggle_call(i[1], ui))

func connect_priorities(ranking: VBoxContainer) -> void:
	for ui in [ranking.priority.growth, ranking.description]:
		for priority in [pursuit, self_control, tenacity]:
			connect_priority(priority, ui)

"""
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

"""
