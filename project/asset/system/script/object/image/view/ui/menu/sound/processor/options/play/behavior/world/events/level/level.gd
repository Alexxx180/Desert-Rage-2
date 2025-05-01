extends BehaviorLevelProgress

const EVENT: int = 0

func tick(mark: Tick) -> int:
	set_progress(mark.blackboard)
	mark.blackboard.set_value("event", EVENT)
	mark.actor.behavior.tick(mark.actor, mark.blackboard)
	return OK
