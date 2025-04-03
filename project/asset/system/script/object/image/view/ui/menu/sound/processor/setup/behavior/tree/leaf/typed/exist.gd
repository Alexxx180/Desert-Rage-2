extends BehaviorAction

func exist(mark: Tick) -> bool:
	return mark.blackboard.get_value("query").context.has("set")

func tick(mark: Tick) -> int:
	return OK if exist(mark) else FAILED
