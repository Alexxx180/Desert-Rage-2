extends BehaviorAction

func tick(mark: Tick) -> int:
	mark.blackboard.get_value("ui").notify("Хлопок").set_slots(mark)
	return ComboBasis.standalone(mark, Skills.PUNCH)
