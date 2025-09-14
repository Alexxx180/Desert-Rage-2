extends BehaviorAction

var basis: SkillBasis = SkillBasis.new()

func get_metadata() -> Array[String]: return ["punch"]

func take_effect(mark: Tick) -> void:
	basis.fight_combo(mark).fight_body("hands")
	basis.x1(mark)
	# basis.notify(mark, "Хлопок")

func tick(mark: Tick) -> int:
	return basis.tick(mark, self)
