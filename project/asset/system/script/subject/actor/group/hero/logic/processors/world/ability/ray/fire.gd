extends AbilitySlot

signal activate(pos: Vector2, damage: int)

const DAMAGE: int = 2

func _set_hero(value: CharacterBody2D) -> void:
	super._set_hero(value)
	_act = _hero.logic.detectors.world.ability.fire.ice

func far_map(_execute: TileMapLayer) -> void:
	_last_position = Vector2.ZERO

func ability() -> void:
	if _vessel != Defaults.CHARACTER and !_vessel.logic.relations.fire.on:
		_vessel.logic.processors.fire.ignite()

	if _last_position != Vector2.ZERO:
		activate.emit(_last_position, DAMAGE)
