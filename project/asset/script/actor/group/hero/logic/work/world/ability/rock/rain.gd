extends AbilitySlot

signal activate(pos: Vector2, dir: Vector2)

func _set_hero(value: CharacterBody2D) -> void:
	super._set_hero(value)
	_act = _hero.logic.see.world.ability.rain.puddle

func animation() -> void:
	_hero.to.moves.set_fight_start("active")
	_hero.to.moves.set_fighting("skill_one")

func _act_sync() -> void:
	activate.emit(_last_position, _act.direction)
	animation()

func ability() -> void:
	if _vessel != HUD.ENTITY and _vessel.logic.link.fire.on and aura.use(cost):
		_vessel.logic.work.fire.freeze()
		_act_sync()
	elif aura.use(cost):
		_act_sync()
