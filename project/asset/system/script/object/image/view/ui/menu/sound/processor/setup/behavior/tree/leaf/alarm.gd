extends SountrackBranchBehavior

func condition(data: Variant) -> bool:
	return data is Array and data.size() > 0 and data[0] is bool

func branch(mark: Tick) -> int:
	var query: SoundtrackTreeQuery = mark.blackboard.get_value("query")
	print("Alarm: ", query.caption)
	mark.actor.branch.set_alarm(query)
	return OK
