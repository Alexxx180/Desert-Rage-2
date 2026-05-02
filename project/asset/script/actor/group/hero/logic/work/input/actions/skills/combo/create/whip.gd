extends BehaviorAction

func tick(mark: Tick) -> int:
	mark.blackboard.g("ui")# .notify("Удар кнутом")
	return ComboBasis.standalone(mark, Skills.WHIP)
