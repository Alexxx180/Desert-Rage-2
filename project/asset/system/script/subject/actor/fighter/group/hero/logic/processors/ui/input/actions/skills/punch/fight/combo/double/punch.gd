extends BehaviorAction

var basis: ComboBasis = ComboBasis.new()

func get_metadata() -> Array[int]:
	var p: int = Skills.PUNCH
	return [p, p]

func fight_combo(combo: Node) -> void:
	combo.start_fight("active")
	combo.fight_body("hands")

func take_effect(mark: Tick) -> void:
	var tools: Dictionary = mark.blackboard.get_value("tools")
	fight_combo(tools.hero.view.animation.moves.combo)
	mark.blackboard.get_value("ui").notify("Двоечка")

func tick(mark: Tick) -> int:
	return basis.tick(mark, self)
