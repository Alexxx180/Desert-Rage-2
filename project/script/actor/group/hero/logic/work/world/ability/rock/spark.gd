extends AbilitySlot

signal activate(pos: Vector2)

func _ready() -> void:
	_act_name = "skill_two"

func _set_hero(value: CharacterBody2D) -> void:
	super._set_hero(value)
	_act = _hero.logic.see.world.ability.spark.puddle

func far_map(_execute: TileMapLayer) -> void:
	# _last_position = Vector2.ZERO
	print("HERO STOP USING: ", _last_position)

func animation() -> void:
	_hero.to.moves.set_fight_start("active")
	_hero.to.moves.set_fighting("skill_two")

func ability() -> void:
	if _vessel != HUD.ENTITY and !_vessel.logic.link.spark.on and aura.use(cost):
		_vessel.logic.work.spark.charge()
	
	print("ROCK SPARK, ", _last_position != Vector2.ZERO)
	if _last_position != Vector2.ZERO and aura.use(cost):
		activate.emit(_last_position); print("USED")
		animation()
