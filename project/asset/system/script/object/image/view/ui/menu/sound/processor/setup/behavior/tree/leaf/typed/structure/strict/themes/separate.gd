extends BehaviorAction

func branch(setup: Node) -> int:
	setup.leaf.themes(setup.ui)
	return OK

func tick(mark: Tick) -> int:
	return branch(mark.blackboard.get_value("setup"))
