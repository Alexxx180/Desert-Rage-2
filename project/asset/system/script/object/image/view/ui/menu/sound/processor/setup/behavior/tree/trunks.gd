extends SountrackBranchBehavior

func condition(data: Variant) -> bool:
	return data.has("type") and data.has("name")

func branch(mark: Tick) -> int:
	var setup: Node = mark.blackboard.get_value("setup")
	var query: SoundtrackTreeQuery = mark.blackboard.get_value("query")
	setup.leaf.set_trunks(setup, query)
	return OK
