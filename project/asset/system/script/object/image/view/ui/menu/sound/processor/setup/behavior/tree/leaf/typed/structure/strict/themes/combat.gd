extends SountrackBranchBehavior

func condition(data: Variant) -> bool:
	return data.size() > 0 and data[0] is Dictionary

func branch(mark: Tick) -> int:
	var setup: Node = mark.blackboard.get_value("setup")
	var query: SoundtrackTreeQuery = mark.blackboard.get_value("query")
	setup.leaf.set_combat(setup, query)
	return OK
