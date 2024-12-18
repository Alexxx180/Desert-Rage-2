extends BehaviorAction

func tick(mark: Tick) -> int:
	if not mark.blackboard.get_value("hide"): return FAILED
	
	for category in ["motion"]:
		for hint in mark.blackboard.get_value("show")[category]:
			hint.ref.hide()
	
	return OK
