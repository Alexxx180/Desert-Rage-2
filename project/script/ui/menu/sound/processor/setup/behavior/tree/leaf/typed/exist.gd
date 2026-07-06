extends BehaviorAction

func exist(mark: Tick) -> bool:
	var context: Variant = mark.blackboard.get_value("query").context
	return context.has("set")

func tick(mark: Tick) -> int:
	return OK if exist(mark) else FAILED
