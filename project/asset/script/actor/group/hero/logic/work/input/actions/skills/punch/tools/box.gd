extends BehaviorAction

func tick(mark: Tick) -> int:
	return FAILED
	var box: Node = mark.blackboard.get_value("tools").box
	var punch: Dictionary = mark.blackboard.get_value("punch")
	
	if punch.pressed and box.is_near:
		box.take_effect()
		return OK
	
	return FAILED
