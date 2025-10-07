extends BehaviorAction

var basis: SkillBasis = SkillBasis.new()

func get_metadata() -> Array[String]: return ["fire"]

func take_effect(mark: Tick) -> void:
	mark.blackboard.get_value("tools").hero.view.animation.effect.set_damage(6)
	basis.fight_combo(mark).fight_body("skill_one")
	basis.x1(mark)
	# basis.notify(mark, "Пламя")

func tick(mark: Tick) -> int:
	return basis.tick(mark, self)
