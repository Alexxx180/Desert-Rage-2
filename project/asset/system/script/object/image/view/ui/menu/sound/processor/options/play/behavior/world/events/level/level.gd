extends BehaviorLevelProgress

func tick(mark: Tick) -> int:
	set_progress(mark.blackboard)
	mark.blackboard.set_value("event", 0)
	return OK
