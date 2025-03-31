extends BehaviorAction

func tick(mark: Tick) -> int:
	var setup: Node = mark.blackboard.get_value("setup")
	setup.leaf.branch(setup.ui)
	return OK
