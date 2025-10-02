extends Node

enum { OUTREACH = 0, READY = 1, JUMPED = 2, ID = 4, HEIGHT = 5, CELL = 64, TRY = 75000 } # 0

var _last_spring: Dictionary = Defaults.DICT
var execute: TileMapLayer
var state: int = OUTREACH
var ground: float = 0.0
var hero: CharacterBody2D
var gravity: Node:
	get: return hero.logic.processors.ui.input.gravity
var mode: Node:
	get: return hero.logic.processors.ui.input.movement.mode

@onready var deactivation: Timer = $deactivation

func spring_enter(_execute: TileMapLayer) -> void:
	execute = _execute
	match state:
		JUMPED:
			if hero.position.y <= ground:
				return_input()
				state = READY
		OUTREACH:
			mode.control.ground = hero.position.y
			state = READY

func deactivate_spring() -> void:
	if _last_spring != Defaults.DICT:
		Tile.switch(_last_spring, Vector2i(1, 0), execute)
		_last_spring = Defaults.DICT

func spring_exit(_execute: TileMapLayer) -> void:
	if state != JUMPED:
		state = OUTREACH

func return_input() -> void:
	mode.control.land()
	gravity.context(true).collide_main().collide(Lay.BORDERS)
	hero.logic.processors.ui.input.modes.select(false)

func perform_jump(_force: float) -> void:
	if _last_spring == Defaults.DICT:
		_last_spring = Tile.from_pos(execute, hero.position)
		Tile.switch(_last_spring, Vector2i(1, 0), execute)
		deactivation.start()
	state = JUMPED
	gravity.context(false).collide_main().collide(Lay.BORDERS)
	hero.logic.processors.ui.input.modes.select(true)
	mode.control.jump()

func successfully_landed() -> void:
	return_input()
	state = OUTREACH

func _input(_event: InputEvent) -> void:
	if state == READY and Input.is_action_just_released("run"):
		perform_jump(1.0)
