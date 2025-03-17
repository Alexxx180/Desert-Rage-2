extends AbilitySlot

signal activate(pos: Vector2)

func _get_action_name() -> String: return "skill_two"

func _set_hero(value: CharacterBody2D) -> void:
	super._set_hero(value)
	_act = _hero.logic.detectors.world.ability.spark.puddle

func ability() -> void:
	if _vessel != Defaults.CHARACTER and !_vessel.logic.relations.spark.on:
		_vessel.logic.processors.spark.charge()
	
	activate.emit(_last_position)
