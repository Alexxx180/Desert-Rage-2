extends BehaviorLevelProgress

class_name BehaviorActionEvent

@export var event: int = 0

func tick(mark: Tick) -> int:
	var key: String = "event"
	if mark.blackboard.compare(key, event):
		set_progress(mark.blackboard)
		mark.blackboard.add_value(key, 1)
		return OK
	return FAILED
