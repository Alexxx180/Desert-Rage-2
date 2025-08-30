extends SkillBasis

class_name ComboBasis

func _continue_process() -> int: return OK

func check_combo(mark: Tick, slots: Array) -> bool:
	var combo: Dictionary = mark.blackboard.get_value("combo")
	var border: int = slots.size()
	if combo.query.size() < border: return false

	var got: bool = true
	var count: int = combo.query.size()
	var offset: int = count - border
	for i in range(0, border):
		var j: int = offset + i
		got = got and combo.query[j] == slots[i]
		print("SLOT: ", i, " - ", combo.query[j], " = ", slots[i])

	Skills.view_actions(combo.query)
	if got: combo.completed = true
	return got
