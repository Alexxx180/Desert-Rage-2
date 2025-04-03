extends BehaviorAction

func branch(mark: Tick) -> int:
	var query: SoundtrackTreeQuery = mark.blackboard.get_value("query")
	print("Themes: ", query.caption)
	mark.actor.branch.set_themes(query)
	return OK

func tick(mark: Tick) -> int:
	return branch(mark)
