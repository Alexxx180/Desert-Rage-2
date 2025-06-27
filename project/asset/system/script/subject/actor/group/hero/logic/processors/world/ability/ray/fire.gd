extends AbilitySlot

signal activate(pos: Vector2, damage: int)

@export var influence: int = 3
@onready var enemy: StaticBody2D = Defaults.STATIC

const DAMAGE: int = 2

func _set_hero(value: CharacterBody2D) -> void:
	super._set_hero(value)
	_act = _hero.logic.detectors.world.ability.fire.ice

func far_map(_execute: TileMapLayer) -> void:
	_last_position = Vector2.ZERO

func near_enemy(hitbox: StaticBody2D) -> void:
	enemy = hitbox

func far_enemy(_hitbox: StaticBody2D) -> void:
	enemy = Defaults.STATIC

func animation() -> void:
	_hero.view.animation.start_fight("active")
	_hero.view.animation.fight_body("hands")

func ability() -> void:
	if enemy != Defaults.STATIC:
		animation()
		enemy.health.burn.contact(influence)
	
	if _vessel != Defaults.CHARACTER and !_vessel.logic.relations.fire.on:
		animation()
		_vessel.logic.processors.fire.ignite()

	if _last_position != Vector2.ZERO:
		activate.emit(_last_position, DAMAGE)
		animation()
