extends Node

signal chained(state: bool)

var input: Node
var view: Node2D
var velocity: Node
var above: bool = false
var climbing: bool = false
var spring: Node:
	get: return input.platforming.spring
var hanging: bool:
	get: return above and climbing

func _catch_ledge() -> void:
	input.modes.select(true)
	chained.emit(true)
	input.gravity.context(false).collide_main()
	view.shadow.hang()
	view.animation.moves.set_environment("chains")

func _decide_moving() -> void:
	if hanging: _catch_ledge()

func move_above(_execute: TileMapLayer) -> void:
	above = true
	if above and spring.state == spring.JUMPED:
		spring.successfully_landed()
		_catch_ledge()
	else:
		_decide_moving()

func move_under(_execute: TileMapLayer) -> void:
	above = false

func climbing_start(_execute: TileMapLayer) -> void:
	climbing = true
	_decide_moving()

func climbing_stop(_execute: TileMapLayer) -> void:
	if not above:
		climbing = false
		input.modes.select(false)
		input.gravity.context(true).collide_main()
		chained.emit(false)
		view.shadow.stand()
		view.animation.moves.set_environment("ground")
