extends SountrackBranchBehavior

func condition(data: Variant) -> bool:
	return data.set is Dictionary and data.mix is int

func branch(mark: Tick) -> int:
	var setup: Node = mark.blackboard.get_value("setup")
	var query: SoundtrackTreeQuery = mark.blackboard.get_value("query")
	setup.leaf.set_blend(setup, query)
	return OK
