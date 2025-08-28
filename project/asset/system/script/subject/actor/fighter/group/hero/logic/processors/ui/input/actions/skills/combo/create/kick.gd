extends BehaviorAction

func tick(mark: Tick) -> int:
	mark.blackboard.get_value("ui").notify("Пинок").set_slots(mark)
	return ComboBasis.standalone(mark, Skills.KICK)
