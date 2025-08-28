extends BehaviorAction

func tick(mark: Tick) -> int:
	mark.blackboard.get_value("ui").notify("Хлопок")
	return ComboBasis.standalone(mark, Skills.PUNCH)
