extends BehaviorAction

func tick(mark: Tick) -> int:
	var value: int = mark.blackboard.get_value("event")
	mark.blackboard.set_value("event", value + 1)
	return OK
