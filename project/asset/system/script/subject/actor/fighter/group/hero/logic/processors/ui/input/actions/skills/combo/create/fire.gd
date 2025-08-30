extends BehaviorAction

func tick(mark: Tick) -> int:
	mark.blackboard.get_value("ui").notify("Пламя")
	return ComboBasis.standalone(mark, Skills.FIRE)
