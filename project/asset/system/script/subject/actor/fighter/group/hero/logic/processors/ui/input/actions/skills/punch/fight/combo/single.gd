extends BehaviorAction

func fight_combo(combo: Node) -> void:
	combo.start_fight("active")
	combo.fight_body("hands")

func tick(mark: Tick) -> int:
	var action: Dictionary = mark.blackboard.get_value("punch")
	var combo: Dictionary = mark.blackboard.get_value("combo")
	if action.toggled:
		var tools: Dictionary = mark.blackboard.get_value("tools")
		fight_combo(tools.hero.view.animation.moves.combo)
		return FAILED
	return FAILED
