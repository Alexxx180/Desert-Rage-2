extends SountrackBranchBehavior

func condition(data: Variant) -> bool:
	return data.set.size() > 0 and data.set[0] is Dictionary

func branch(mark: Tick) -> int:
	var query: SoundtrackTreeQuery = mark.blackboard.get_value("query")
	print("Combat: ", query.caption)
	mark.actor.branch.set_combat(query)
	return OK
