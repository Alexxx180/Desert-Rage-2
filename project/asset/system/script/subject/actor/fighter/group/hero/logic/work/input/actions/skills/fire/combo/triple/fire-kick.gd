extends BehaviorAction

var basis: ComboBasis = ComboBasis.new()

func get_metadata() -> Array[int]:
	var k: int = Skills.KICK
	var f: int = Skills.FIRE
	return [k, f, k]

func take_effect(mark: Tick) -> void:
	basis.fight_combo(mark).fight_body("legs")
	basis.x(mark, Skills.TRIPLE).notify(mark, "Ноги-гриль")

func tick(mark: Tick) -> int:
	return basis.tick(mark, self)
