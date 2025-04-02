extends BehaviorAction

func branch(mark: Tick) -> int:
	var setup: Node = mark.blackboard.get_value("setup")
	var query: SoundtrackTreeQuery = mark.blackboard.get_value("query")
	setup.leaf.set_themes(setup, query)
	return OK

func tick(mark: Tick) -> int:
	return branch(mark)
