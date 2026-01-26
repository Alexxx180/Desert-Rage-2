extends BehaviorAction

func tick(mark: Tick) -> int:
	if not mark.blackboard.g("hide"): return FAILED
	
	var show: Dictionary = mark.blackboard.g("ref")
	
	for head in ["motion", "action", "reason"]:
		for ref in show[head].values(): ref.hide()
		
	return OK
