extends AbilitySlot

signal activate(pos: Vector2)

func _get_action_name() -> String: return "skill_two"

func _set_hero(value: CharacterBody2D) -> void:
	super._set_hero(value)
	_act = _hero.logic.detectors.world.ability.spark.puddle

func far_map(_execute: TileMapLayer) -> void:
	_last_position = Vector2.ZERO

func ability() -> void:
	if _vessel != Defaults.CHARACTER and !_vessel.logic.relations.spark.on:
		_vessel.logic.processors.spark.charge()
	
	if _last_position != Vector2.ZERO:
		activate.emit(_last_position)
