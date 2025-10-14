extends BehaviorAction

func tick(mark: Tick) -> int:
	var tools: Dictionary = mark.blackboard.get_value("tools")
	print("CHAINS CHECK PASSED: ", tools.pillar.achievable)
	if tools.pillar.achievable:
		print("TAKE EFFECT")
		tools.pillar.take_effect()
		# tools.strike.pillar.take_effect()
		# tools.hero.view.animation.moves.combo.start_fight("active")
		 #tools.hero.view.animation.moves.combo.fight_body("hands")
		return OK
	return FAILED
