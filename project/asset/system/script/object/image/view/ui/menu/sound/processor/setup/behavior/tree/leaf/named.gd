extends SountrackBranchBehavior

func condition(data: Variant) -> bool:
	return data is Dictionary and data.values()[0] is String

func branch(mark: Tick) -> int:
	var query: SoundtrackTreeQuery = mark.blackboard.get_value("query")
	print("Named: ", query.caption)
	mark.actor.branch.set_named(query)
	return OK
