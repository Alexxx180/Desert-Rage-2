extends Node

enum { HORIZONTAL = 0, ALL = 1 }

var input: Node
var above: bool = false
var climbing: bool = false

func move_above(execute: TileMapLayer) -> void:
	above = true
	if above and climbing:
		input.axis = HORIZONTAL
		input.gravity.turn_walls_collision(false)

func move_under(execute: TileMapLayer) -> void:
	above = false

func climbing_start(execute: TileMapLayer) -> void:
	climbing = true

func climbing_stop(execute: TileMapLayer) -> void:
	if not above:
		climbing = false
		input.axis = ALL
		input.gravity.turn_walls_collision(true)
