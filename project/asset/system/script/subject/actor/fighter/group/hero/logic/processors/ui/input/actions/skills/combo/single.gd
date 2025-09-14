extends RefCounted

class_name SkillBasis

func _continue_process() -> int: return FAILED

func check_combo(mark: Tick, slots: Array) -> bool:
	return mark.blackboard.get_value(slots[0]).released

func fight_combo(mark: Tick) -> Node:
	var tools: Dictionary = mark.blackboard.get_value("tools")
	var combo: Node = tools.hero.view.animation.moves.combo
	combo.start_fight("active")
	return combo

func tick(mark: Tick, act: BehaviorAction) -> int:
	if check_combo(mark, act.get_metadata()):
		print("GOT A COMBO!")
		act.take_effect(mark)
		return _continue_process()
	return FAILED

func x1(mark: Tick) -> SkillBasis:
	mark.blackboard.get_value("group").xp.multiply.hit()
	return self

func notify(mark: Tick, caption: String) -> void:
	mark.blackboard.get_value("ui").set_slot_combo(caption)

static func standalone(mark: Tick, slot: int) -> int:
	var combo: Dictionary = mark.blackboard.get_value("combo")
	
	combo.query.push_back(slot)
	if combo.query.size() > combo.max:
		combo.query.pop_front()

	combo.timer.start()
	combo.completed = false
	Skills.view_actions(combo.query)
	return FAILED
