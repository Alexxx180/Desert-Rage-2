extends BehaviorAction

var caption: int = 0

func tick(mark: Tick) -> int:
	var key: String = "level_name"
	return OK if mark.blackboard.compare(key, caption) else FAILED
