extends Label

var description: Array[String] = ["PR", "CM", "PE"]

func connect_priority(p: Button, record: VBoxContainer, method: String) -> void:
	# var selection: VBoxContainer = record.ranking.priority.selection
	var heroes: HBoxContainer = record.ranking.priority.growth.heroes
	var c: Array = [["nter", func(): # priority[record.selected].hide() # priority[p.priority_no].show()
		text = "P%sD" % description[p.priority_no]
		heroes.leader.stats.toggle(p.priority_no, "show")
	], ["xit", func():
		heroes.leader.stats.set_priority(p.priority_no)
		heroes.leader.priority.priorities[record.selected].show()
	]]
	for s in c: p.get("%s_e%sed" % [method, s[0]]).connect(s[1])

func connect_priorities(record: VBoxContainer) -> void:
	for p in record.priorities:
		for method in ["focus", "mouse"]:
			connect_priority(p, record, method)
