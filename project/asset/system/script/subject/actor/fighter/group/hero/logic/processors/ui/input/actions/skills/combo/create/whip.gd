extends BehaviorAction

func tick(mark: Tick) -> int:
	mark.blackboard.get_value("ui").notify("Удар кнутом")
	return ComboBasis.standalone(mark, Skills.WHIP)
