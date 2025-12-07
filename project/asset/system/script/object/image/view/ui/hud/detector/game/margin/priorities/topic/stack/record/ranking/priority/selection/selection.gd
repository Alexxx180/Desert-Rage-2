extends VBoxContainer

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
