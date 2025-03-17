extends AbilitySlot

signal activate(pos: Vector2, damage: int)

const DAMAGE: int = 2

var _burn: bool = false

func _set_hero(value: CharacterBody2D) -> void:
	super._set_hero(value)
	_act = _hero.logic.detectors.world.ability.fire.ice

func near_map(_execute: TileMapLayer) -> void:
	super.near_map(_execute)
	_burn = true

func far_map(_execute: TileMapLayer) -> void:
	_burn = false

func ability() -> void:
	if _vessel != Defaults.CHARACTER and !_vessel.logic.relations.fire.on:
		_vessel.logic.processors.fire.ignite()
	
	if _burn: activate.emit(_last_position, DAMAGE)
