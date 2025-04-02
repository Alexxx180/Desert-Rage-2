extends SountrackBranchBehavior

func condition(data: Variant) -> bool:
	return data is Array and data.size() > 0 and data[0] is bool

func branch(mark: Tick) -> int:
	var setup: Node = mark.blackboard.get_value("setup")
	var query: SoundtrackTreeQuery = mark.blackboard.get_value("query")
	setup.leaf.set_alarm(setup, query)
	return OK
