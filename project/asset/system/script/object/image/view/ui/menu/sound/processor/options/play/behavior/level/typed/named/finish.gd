extends BehaviorAction

func tick(mark: Tick) -> int:
	mark.blackboard.set_value("level", false)
	#mark.actor.behavior.tick(mark.actor, mark.blackboard)
	return OK
