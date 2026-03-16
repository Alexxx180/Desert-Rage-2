extends BehaviorAction

var basis: SkillBasis = SkillBasis.new()

func get_metadata() -> Array[String]: return ["whip"]

func take_effect(mark: Tick) -> void:
	mark.blackboard.g("tools").hero.view.animation.effect.set_damage(7)
	basis.fight_combo(mark).fight_body("skill_two")
	basis.x1(mark)
	# basis.notify(mark, "Удар кнутом")

func tick(mark: Tick) -> int:
	return basis.tick(mark, self)
