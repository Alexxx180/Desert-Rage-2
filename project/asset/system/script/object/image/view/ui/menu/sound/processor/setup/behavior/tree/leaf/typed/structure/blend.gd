extends SountrackBranchBehavior

func condition(data: Variant) -> bool:
	return data.set is Dictionary and data.mix is float

func branch(mark: Tick) -> int:
	var query: SoundtrackTreeQuery = mark.blackboard.get_value("query")
	print("Blend: ", query.caption)
	mark.actor.branch.set_blend(query)
	return OK
