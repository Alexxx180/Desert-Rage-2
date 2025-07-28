extends Node

enum { OUTREACH = 0, READY = 1, JUMPED = 2, ID = 4, HEIGHT = 5, CELL = 64, TRY = 75000 } # 0

var state: int = OUTREACH
var ground: float = 0.0
var hero: CharacterBody2D
var gravity: Node:
	get: return hero.logic.processors.ui.input.gravity
var mode: Node:
	get: return hero.logic.processors.ui.input.movement.mode

func spring_enter(_execute: TileMapLayer) -> void:
	match state:
		JUMPED:
			if hero.position.y <= ground: return_input()
		OUTREACH:
			# var cell: Dictionary = Tile.from_pos(execute, hero.position)
			mode.control.ground = hero.position.y
			# hero.position.y += 1
			state = READY
# 			if cell.id == ID and cell.atlas in [Vector2i(0, 2), Vector2i(0, 3)]:
#				mode.control.ground = cell.pos.y + 20
#				state = READY

func spring_exit(_execute: TileMapLayer) -> void:
	if state != JUMPED: state = OUTREACH

func return_input() -> void:
	mode.control.land()
	print("STOP RIGHT THERE")
	state = OUTREACH # hero.motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	gravity.turn_walls_collision(true, true)
	hero.logic.processors.ui.input.modes.select(false)
	# mode.control.jumped = false

func perform_jump(_force: float) -> void:
	state = JUMPED
	gravity.turn_walls_collision(false, true)
	hero.logic.processors.ui.input.modes.select(true)
	mode.control.jump()
	# mode.control.height = -TRY
	# mode.control.jumped = true

func successfully_landed() -> void:
	return_input()
	# if state == JUMPED: return_input()

func _input(_event: InputEvent) -> void:
	if state == READY:
		var action: float = Input.get_action_strength("run")
		if action != 0: perform_jump(action)
