extends BehaviorAction

func tick(mark: Tick) -> int:
	var tools: Dictionary = mark.blackboard.get_value("tools")
	if tools.strike.book.is_near:
		tools.strike.book.take_effect()
		return OK
	return FAILED
