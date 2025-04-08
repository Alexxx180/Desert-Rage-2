extends BehaviorAction

const RAMPAGE: int = 1

func tick(mark: Tick) -> int:
	var value: int = mark.blackboard.get_value("rampage")
	return OK if value == RAMPAGE else FAILED
