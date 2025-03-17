extends AbilitySlot

signal activate(pos: Vector2, dir: Vector2)

func _set_hero(value: CharacterBody2D) -> void:
	super._set_hero(value)
	_act = _hero.logic.detectors.world.ability.rain.puddle

func ability() -> void:
	if _vessel != Defaults.CHARACTER and !_vessel.logic.relations.fire.on:
		_vessel.logic.processors.fire.freeze()
	
	activate.emit(_last_position, _act.direction)
