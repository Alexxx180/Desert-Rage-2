extends BehaviorAction

func tick(mark: Tick) -> int:
	var setup: Node = mark.blackboard.get_value("setup")
	var context: Dictionary = mark.blackboard.get_value("context")
	setup.leaf.set_branch(setup.ui, context)
	return OK
