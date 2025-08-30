extends BehaviorAction

func tick(mark: Tick) -> int:
	var tools: Dictionary = mark.blackboard.get_value("tools")
	if tools.stomp.box.is_near:
		tools.stomp.box.take_effect()
		tools.hero.view.animation.moves.combo.start_fight("active")
		tools.hero.view.animation.moves.combo.fight_body("legs")
		return OK
	return FAILED
