extends BehaviorAction

func tick(mark: Tick) -> int:
	#print("HIDE IS: ", not mark.blackboard.get_value("hide"))
	if not mark.blackboard.get_value("hide"): return FAILED
	
	var show: Dictionary = mark.blackboard.get_value("ref")
	
	for head in ["motion"]:
		for ref in show[head].values(): ref.hide()
	
	return OK
