extends BehaviorAction

var basis: ComboBasis = ComboBasis.new()

func get_metadata() -> Array[int]:
	var p: int = Skills.PUNCH
	var w: int = Skills.WHIP
	return [p, w, p, w]

func take_effect(mark: Tick) -> void:
	basis.fight_combo(mark).fight_body("hands")
	basis.notify(mark, "Порка")

func tick(mark: Tick) -> int:
	return basis.tick(mark, self)
