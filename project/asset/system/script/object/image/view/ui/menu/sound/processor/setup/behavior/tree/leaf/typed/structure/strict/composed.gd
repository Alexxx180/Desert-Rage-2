extends BehaviorAction

func tick(mark: Tick) -> int:
	var query: SoundtrackTreeQuery = mark.blackboard.get_value("query")
	return OK if query.context.set is Array else FAILED
