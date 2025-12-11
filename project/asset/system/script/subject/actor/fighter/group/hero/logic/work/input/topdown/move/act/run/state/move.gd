extends Node

enum { WALK = 1, RUN = 2, DELAY = 5 } # ACTION = 20, 

signal stop_mach() # signal new_mach(next: int)

@export var available_bar: bool = true

var running: bool = false
var atb: RangeATB = RangeATB.new()
var hero: CharacterBody2D
var walk_transit: bool:
	get: return running and not atb.go

func reset_mach() -> void: stop_mach.emit()
func to_walk() -> void: set_speed(WALK)
func to_run() -> void: set_speed(RUN)

func set_speed(state: int) -> void:
	running = state == RUN
	hero.view.animation.moves.set_walk_speed(state)
	hero.logic.stats.accelerate(state)

func is_delayed(next) -> bool:
	return available_bar and next >= DELAY
