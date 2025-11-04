extends BehaviorAction

var basis: SkillBasis = SkillBasis.new()

func get_metadata() -> Array[String]: return ["kick"]

func take_effect(mark: Tick) -> void:
	basis.fight_combo(mark).fight_body("legs")
	basis.x1(mark).vfx_hint(mark, mark.actor.kick) # .notify(mark, "Пинок")

func tick(mark: Tick) -> int:
	return basis.tick(mark, self)
