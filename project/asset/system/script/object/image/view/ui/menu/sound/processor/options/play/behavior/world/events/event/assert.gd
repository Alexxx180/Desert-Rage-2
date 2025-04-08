extends BehaviorAction

@export var event: int = 0

func tick(mark: Tick) -> int:
	return OK if mark.blackboard.get_value("event") == event else FAILED
