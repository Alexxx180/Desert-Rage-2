extends SountrackBranchBehavior

func condition(data: Variant) -> bool:
	return data.has("type") and data.has("name")

func branch(mark: Tick) -> int:
	var query: SoundtrackTreeQuery = mark.blackboard.get_value("query")
	print("Trunk: ", query.caption)
	mark.actor.branch.set_trunks(mark.actor, query)
	return OK
