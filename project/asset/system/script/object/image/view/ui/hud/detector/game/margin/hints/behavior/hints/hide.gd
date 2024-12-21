extends BehaviorAction

func tick(mark: Tick) -> int:
	if not mark.blackboard.get_value("hide"): return FAILED
	
	var show: Dictionary = mark.blackboard.get_value("ref")
	
	for head in ["motion", "action", "reason"]:
		for ref in show[head].values(): ref.hide()
		
	return OK
