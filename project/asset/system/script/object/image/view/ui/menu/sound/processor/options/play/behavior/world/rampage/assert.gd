extends BehaviorAction

const RAMPAGE: int = 1

func tick(mark: Tick) -> int:
	var key: String = "rampage"
	return OK if mark.blackboard.compare(key, RAMPAGE) else FAILED
