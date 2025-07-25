extends Node

signal chained(state: bool)

enum { HORIZONTAL = 0, ALL = 1 }

var input: Node
var velocity: Node
var above: bool = false
var climbing: bool = false

func _decide_moving() -> void:
	if above and climbing:
		input.axis = HORIZONTAL
		chained.emit(true)
		#velocity.forget_velocity()
		#input.gravity.turn_walls_collision(false)

func move_above(_execute: TileMapLayer) -> void:
	above = true
	_decide_moving()

func move_under(_execute: TileMapLayer) -> void:
	above = false

func climbing_start(_execute: TileMapLayer) -> void:
	climbing = true
	_decide_moving()

func climbing_stop(_execute: TileMapLayer) -> void:
	if not above:
		climbing = false
		input.axis = ALL
		input.gravity.turn_walls_collision(true)
		chained.emit(false)
