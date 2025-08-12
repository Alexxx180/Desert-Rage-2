extends BehaviorAction

func fight(combo: Node) -> void:
	combo.start_fight("active")
	combo.fight_tool("bash")

func tick(mark: Tick) -> int:
	var tools: Dictionary = mark.blackboard.get_value("tools")
	if tools.strike.book.is_near:
		tools.strike.book.take_effect()
		fight(tools.hero.view.animation.moves.combo)
		return OK
	return FAILED
