extends BehaviorAction

func tick(mark: Tick) -> int:
	mark.blackboard.g("ui")# .notify("Хлопок")
	return ComboBasis.standalone(mark, Skills.PUNCH)
