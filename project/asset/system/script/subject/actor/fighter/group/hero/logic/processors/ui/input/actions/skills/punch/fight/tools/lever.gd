extends BehaviorAction

func tick(mark: Tick) -> int:
	var tools: Dictionary = mark.blackboard.get_value("tools")
	if tools.lever.is_near:
		tools.lever.take_effect()
		tools.strike.lever.take_effect()
		return OK
	return FAILED
