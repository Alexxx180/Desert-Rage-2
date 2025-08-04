extends BehaviorAction

func tick(mark: Tick) -> int:
	var action: Dictionary = mark.blackboard.get_value("punch")
	var combo: Dictionary = mark.blackboard.get_value("combo")
	if action.toggled:
		combo.single.take_effect()
		return FAILED
	return FAILED
