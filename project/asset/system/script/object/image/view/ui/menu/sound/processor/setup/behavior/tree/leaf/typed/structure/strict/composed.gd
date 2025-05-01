extends BehaviorAction

func tick(mark: Tick) -> int:
	var query = mark.blackboard.get_value("query")
	return OK if query.context.set is Array else FAILED
