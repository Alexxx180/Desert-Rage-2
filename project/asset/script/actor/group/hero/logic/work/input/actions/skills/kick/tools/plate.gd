extends BehaviorAction

func fight(combo: Node) -> void:
	combo.start_fight("active")
	combo.fight_tool("stomp")

func tick(mark: Tick) -> int:
	var tools: Dictionary = mark.blackboard.g("tools")
	if tools.stomp.plate.is_near:
		tools.stomp.plate.take_effect()
		fight(tools.hero.view.animation.moves.combo)
		return OK
	return FAILED
