extends BehaviorAction

func branch(setup: Node, context: Dictionary) -> int:
	setup.leaf.set_themes(setup.ui, context)
	return OK

func tick(mark: Tick) -> int:
	var setup: Node = mark.blackboard.get_value("setup")
	var context: Dictionary = mark.blackboard.get_value("context")
	return branch(setup, context)
