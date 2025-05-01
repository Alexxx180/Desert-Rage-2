extends BehaviorAction

func tick(mark: Tick) -> int:
	return OK if mark.blackboard.get_value("level") else FAILED
