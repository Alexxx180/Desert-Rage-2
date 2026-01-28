extends BehaviorAction

func tick(mark: Tick) -> int:
	mark.blackboard.g("ui")# .notify("Пинок")
	return ComboBasis.standalone(mark, Skills.KICK)
