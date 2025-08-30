extends BehaviorAction

var basis: SkillBasis = SkillBasis.new()

func get_metadata() -> Array[String]: return ["kick"]

func take_effect(mark: Tick) -> void:
	basis.fight_combo(mark).fight_body("legs")
	basis.notify(mark, "Пинок")

func tick(mark: Tick) -> int:
	return basis.tick(mark, self)
