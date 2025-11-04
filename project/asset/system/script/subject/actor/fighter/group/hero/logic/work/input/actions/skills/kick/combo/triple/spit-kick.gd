extends BehaviorAction

var basis: ComboBasis = ComboBasis.new()

func get_metadata() -> Array[int]:
	var p: int = Skills.PUNCH
	var k: int = Skills.KICK
	return [k, p, k]

func fight_combo(combo: Node) -> void:
	combo.start_fight("active")
	combo.fight_body("legs")

func take_effect(mark: Tick) -> void:
	var tools: Dictionary = mark.blackboard.get_value("tools")
	fight_combo(tools.hero.view.animation.moves.combo)
	basis.vfx_hint(mark, mark.actor.kick)
	basis.notify(mark, "Косой удар")
	mark.blackboard.get_value("group").xp.multiply.by_slots(Skills.TRIPLE)

func tick(mark: Tick) -> int:
	return basis.tick(mark, self)
