extends BehaviorAction

func exist(context: Dictionary) -> bool:
	return context.has("set")

func tick(mark: Tick) -> int:
	return OK if exist(mark.blackboard.get_value("context")) else FAILED
