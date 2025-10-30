extends BehaviorAction

var basis: SkillBasis = SkillBasis.new()

func get_metadata() -> Array[String]: return ["kick"]

func take_effect(mark: Tick) -> void:
	basis.fight_combo(mark).fight_body("legs")
	basis.x1(mark)# .notify(mark, "Пинок")
	var vfx: Sprite2D = mark.actor.kick.instantiate()
	var hero: CharacterBody2D = mark.blackboard.get_value("tools").hero
	hero.group.lay.execute.layer.add_child(vfx)
	vfx.set_direction(hero.position, hero.logic.see.dir)

func tick(mark: Tick) -> int:
	return basis.tick(mark, self)
