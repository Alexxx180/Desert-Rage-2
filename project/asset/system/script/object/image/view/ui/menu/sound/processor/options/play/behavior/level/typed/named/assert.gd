extends BehaviorAction

var caption: int = 0

func tick(mark: Tick) -> int:
	var value = mark.blackboard.get_value("level_name")
	return OK if value == caption else FAILED
