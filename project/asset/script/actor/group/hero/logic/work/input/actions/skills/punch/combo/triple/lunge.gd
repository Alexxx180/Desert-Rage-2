extends BehaviorAction

var basis: ComboBasis = ComboBasis.new()

func get_metadata() -> Array[int]:
	var p: int = Skills.PUNCH
	var k: int = Skills.KICK
	return [k, p, p]

func take_effect(mark: Tick) -> void:
	basis.fight_combo(mark).fight_body("hands")
	basis.x(mark, Skills.TRIPLE).vfx_hint(mark, mark.actor.kick)
	basis.notify(mark, "Выпад")

func tick(mark: Tick) -> int:
	return basis.tick(mark, self)
