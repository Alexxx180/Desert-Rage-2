extends BehaviorAction

func tick(mark: Tick) -> int:
	var query = mark.blackboard.get_value("query")
	print("Branch: ", query.caption)
	mark.actor.branch.set_branch(mark.actor, query)
	return OK
