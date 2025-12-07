extends VBoxContainer

@onready var priority: Array[Label] = [$pursuit, $self_control, $tenacity]

func connect_priority(p: Button, record: VBoxContainer, method: String) -> void:
	var c: Array = [["nter", func():
		priority[record.selected].hide()
		priority[p.priority_no].show()
	], ["xit", func():
		priority[p.priority_no].hide()
		priority[record.selected].show()
	]]
	for s in c: p.get("%s_e%sed" % [method, s[0]]).connect(s[1])

func connect_priorities(record: VBoxContainer) -> void:
	for p in record.priorities:
		for method in ["focus", "mouse"]:
			connect_priority(p, record, method)
