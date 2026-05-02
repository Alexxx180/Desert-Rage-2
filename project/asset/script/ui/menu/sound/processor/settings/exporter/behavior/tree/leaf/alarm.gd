extends BehaviorAction

func condition(data: Variant) -> bool:
	return data is Array and data.size() > 0 and data[0] is bool

func branch(mark: Tick) -> int:
	var query: SoundtrackExportQuery = mark.blackboard.get_value("query")
	mark.actor.set_alarm(query.context[1], query.path)
	return OK
