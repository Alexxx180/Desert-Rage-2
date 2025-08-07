extends BehaviorAction

func tick(mark: Tick) -> int:
	var tools: Dictionary = mark.blackboard.get_value("tools")
	if tools.stomp.plate.is_near:
		tools.stomp.plate.take_effect()
		return OK
	return FAILED
