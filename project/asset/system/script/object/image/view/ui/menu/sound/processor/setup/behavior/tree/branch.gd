extends BehaviorAction

func tick(mark: Tick) -> int:
	var setup: Node = mark.blackboard.get_value("setup")
	var query: Dictionary = mark.blackboard.get_value("query")
	setup.leaf.set_branch(setup, query)
	return OK
