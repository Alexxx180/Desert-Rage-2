extends BehaviorAction

var basis: SkillBasis = SkillBasis.new()

func get_metadata() -> Array[String]: return ["punch"]

func take_effect(mark: Tick) -> void:
	basis.fight_combo(mark).fight_body("hands")
	basis.x1(mark)
	var vfx: Sprite2D = mark.actor.punch.instantiate()
	var hero: CharacterBody2D = mark.blackboard.get_value("tools").hero
	hero.group.lay.execute.layer.add_child(vfx)
	vfx.set_direction(hero.position, hero.logic.see.dir)
	
	# basis.notify(mark, "Хлопок")

func tick(mark: Tick) -> int:
	return basis.tick(mark, self)
