extends BehaviorAction

func tick(mark: Tick) -> int:
	var tools: Dictionary = mark.blackboard.g("tools")
	# print("WHIP CHECK PASSED: ", tools.pillar.is_near)
	if tools.pillar.is_near:
		tools.pillar.take_effect()
		# tools.strike.pillar.take_effect()
		# tools.hero.view.animation.moves.combo.start_fight("active")
		 #tools.hero.view.animation.moves.combo.fight_body("hands")
		return OK
	return FAILED
