extends BehaviorAction

func tick(mark: Tick) -> int:
	mark.blackboard.add_value("event", 1)
	return OK
