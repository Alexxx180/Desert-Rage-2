extends BehaviorAction

func tick(mark: Tick) -> int:
	var context: Dictionary = mark.blackboard.get_value("context")
	return OK if context.set is Array else FAILED
