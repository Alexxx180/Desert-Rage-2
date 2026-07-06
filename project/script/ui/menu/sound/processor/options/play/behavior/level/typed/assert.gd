extends BehaviorAction

var type: int = 0

func tick(mark: Tick) -> int:
	var value = mark.blackboard.get_value("level_type")
	return OK if value == type else FAILED
