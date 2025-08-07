extends RefCounted

class_name ComboBasis

func check_combo(mark: Tick, slots: Array[int]) -> bool:
	var combo: Dictionary = mark.blackboard.get_value("combo")
	var border: int = slots.size()
	if combo.query.size() < border: return false

	const n: int = -1

	var got: bool = true
	for i in range(border - 1, n, n):
		got = got and combo.query[i] == slots[i]
		print("SLOT: ", i, " - ", combo.query[i], " = ", slots[i])

	Skills.view_actions(combo.query)
	print("SLOTS: ", slots)
	if got:
		# 
		combo.completed = true
		
	return got

func tick(mark: Tick, act: BehaviorAction) -> int:
	if check_combo(mark, act.get_metadata()):
		print("GOT A COMBO!")
		act.take_effect(mark)
		return OK
	return FAILED

static func standalone(mark: Tick, slot: int) -> int:
	var combo: Dictionary = mark.blackboard.get_value("combo")
	
	combo.query.push_front(slot)
	if combo.query.size() > combo.max:
		combo.query.pop_front()
	combo.timer.start()
	combo.completed = false
	Skills.view_actions(combo.query)
	return FAILED
