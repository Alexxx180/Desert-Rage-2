extends BehaviorAction

var basis: ComboBasis = ComboBasis.new()

func get_metadata() -> Array[int]:
	var p: int = Skills.PUNCH
	var k: int = Skills.KICK
	return [k, p, p]

func fight_combo(combo: Node) -> void:
	combo.start_fight("active")
	combo.fight_body("hands")

func take_effect(mark: Tick) -> void:
	var tools: Dictionary = mark.blackboard.get_value("tools")
	fight_combo(tools.hero.view.animation.moves.combo)
	mark.blackboard.get_value("ui").notify("Выпад")

func tick(mark: Tick) -> int:
	# print("TRIPLE PUNCH START")
	return basis.tick(mark, self)
