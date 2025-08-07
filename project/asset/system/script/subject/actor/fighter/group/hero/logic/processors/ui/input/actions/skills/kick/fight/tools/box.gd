extends BehaviorAction

func tick(mark: Tick) -> int:
	var tools: Dictionary = mark.blackboard.get_value("tools")
	if tools.stomp.box.is_near:
		tools.stomp.box.take_effect()
		return OK
	return FAILED
