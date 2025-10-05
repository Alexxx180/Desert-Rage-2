extends Node

enum { STAND = -1, WALK = 1, RUN = 2, DELAY = 5, MIN = 0, ACTION = 20, MACH = 35, MAX = 40 }

signal new_mach(next: int)
signal stop_mach()

@export var available_bar: bool = true

var running: bool = false
var mach: Vector2i = Vector2i(ACTION, MIN)
var hero: CharacterBody2D

func is_run_start(motion: Vector2) -> bool:
	mach.y = decide_speed(motion)
	return initial() and mach.y == WALK

func decide_speed(motion: Vector2) -> int:
	return STAND if motion == Vector2.ZERO else WALK

func set_mach(next: int) -> void:
	mach.x = next
	new_mach.emit(next)

func reset_mach() -> void: stop_mach.emit()
func to_walk() -> void: set_speed(WALK)
func to_run() -> void: set_speed(RUN)

func run_transit() -> bool: return mach.x == MACH
func walk_transit() -> bool: return running and mach.x < MACH

func set_speed(state: int) -> void:
	running = state == RUN
	hero.view.animation.moves.set_walk_speed(state)
	hero.logic.stats.accelerate(state)

func initial() -> bool: return mach.x == ACTION
func is_delayed(next) -> bool: return available_bar and next >= DELAY
func strict_action() -> bool: return initial() and mach.y != WALK

func upper() -> int: return clampi(mach.x + mach.y, ACTION, MAX)
func lower() -> int: return mach.x + 1
func set_atb_mach() -> void:
	set_mach(upper() if mach.x >= ACTION else lower())
