extends BehaviorAction

var basis: ComboBasis = ComboBasis.new()

func get_metadata() -> Array[int]:
	var p: int = Skills.PUNCH
	return [p, p]

func take_effect(mark: Tick) -> void:
	var text: String = "Двоечка"
	basis.fight_combo(mark).fight_body("hands")
	basis.x(mark, Skills.DOUBLE).notify(mark, text)

func tick(mark: Tick) -> int:
	return basis.tick(mark, self)
