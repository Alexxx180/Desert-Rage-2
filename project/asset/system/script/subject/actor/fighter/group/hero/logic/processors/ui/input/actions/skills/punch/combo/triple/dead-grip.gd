extends BehaviorAction

var basis: ComboBasis = ComboBasis.new()

func get_metadata() -> Array[int]:
	var p: int = Skills.PUNCH
	var w: int = Skills.WHIP
	return [p, w, p]

func take_effect(mark: Tick) -> void:
	basis.fight_combo(mark).fight_body("hands")
	basis.x(mark, Skills.TRIPLE).notify(mark, "Мертвая хватка")

func tick(mark: Tick) -> int:
	return basis.tick(mark, self)
