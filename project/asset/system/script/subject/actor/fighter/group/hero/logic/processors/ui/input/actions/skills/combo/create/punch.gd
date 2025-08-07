extends BehaviorAction

func tick(mark: Tick) -> int:
	return ComboBasis.standalone(mark, Skills.PUNCH)
