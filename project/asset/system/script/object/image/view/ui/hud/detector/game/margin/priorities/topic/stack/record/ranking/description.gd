extends VBoxContainer

@onready var priority: Array[Label] = [$pursuit, $self_control, $tenacity]

func connect_priority(p: Button, record: VBoxContainer, method: String) -> void:
	var selection: VBoxContainer = record.ranking.priority.selection
	var heroes: HBoxContainer = record.ranking.priority.growth.heroes
	var c: Array = [["nter", func():
		priority[record.selected].hide()
		priority[p.priority_no].show()
		for ps in heroes.leader.priority.priorities: ps.hide()
		heroes.leader.stats.toggle(p.priority_no, "show")
	], ["xit", func():
		priority[p.priority_no].hide()
		priority[record.selected].show()
		heroes.leader.stats.toggle(p.priority_no, "hide")
		heroes.leader.priority.priorities[record.selected].show()
	]]
	for s in c: p.get("%s_e%sed" % [method, s[0]]).connect(s[1])

func connect_priorities(record: VBoxContainer) -> void:
	for p in record.priorities:
		for method in ["focus", "mouse"]:
			connect_priority(p, record, method)
