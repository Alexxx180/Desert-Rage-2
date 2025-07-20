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
	_hero.view.animation.moves.set_fight_start("active")
	_hero.view.animation.moves.set_fighting("hands")

func ability() -> void:
	if enemy != Defaults.STATIC and aura.use(cost):
		animation()
		enemy.fire(_hero.logic.stats.influence)
	
	if _vessel != Defaults.CHARACTER and !_vessel.logic.relations.fire.on and aura.use(cost):
		animation()
		_vessel.logic.processors.fire.ignite()

	if _last_position != Vector2.ZERO and aura.use(cost):
		activate.emit(_last_position, DAMAGE)
		animation()
