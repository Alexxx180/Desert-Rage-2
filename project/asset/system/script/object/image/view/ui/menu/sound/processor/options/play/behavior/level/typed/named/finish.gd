extends BehaviorAction

func tick(mark: Tick) -> int:
	mark.blackboard.set_value("level", false)
	mark.blackboard.set_value("rampage", 0)
	mark.actor.behavior.tick(mark.actor, mark.blackboard)
	return OK
