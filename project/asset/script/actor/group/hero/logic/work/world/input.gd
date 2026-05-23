class_name WorldInput extends RefCounted

func _input(event):
	d

















































"""
enum { WORLD, BORDERS, ENTITY, GROUND, TRIGGER, GAP = 7, UPLAND = 8, GRAVITY = 700000, JUMP = 200000 }

@onready var move: Node = $move
@onready var levels: Node = $levels
@onready var actions: Node = $actions

func _ready() -> void:
	move.act.levels = levels
	move.act.actions = actions

func input(event: InputEvent) -> void: move.device.input(event)

func on_select() -> void: pass

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
"""
