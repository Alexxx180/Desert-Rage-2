extends BehaviorAction

func tick(mark: Tick) -> int:
	var tools: Dictionary = mark.blackboard.g("tools")
	if tools.lever.is_near:
		tools.lever.take_effect()
		tools.strike.lever.take_effect()
		tools.hero.view.animation.moves.combo.start_fight("active")
		tools.hero.view.animation.moves.combo.fight_body("hands")
		return OK
	return FAILED
