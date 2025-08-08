extends RefCounted

class_name ComboBasis

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
	# print("SLOTS: ", slots)
	if got: # 
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
	
	#combo.query.push_front(slot)
	combo.query.push_back(slot)
	if combo.query.size() > combo.max:
		combo.query.pop_front()
		#combo.query.pop_back()
	combo.timer.start()
	combo.completed = false
	Skills.view_actions(combo.query)
	return FAILED
