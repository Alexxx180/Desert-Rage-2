extends Node

signal chained(state: bool)

@onready var catch: Node = $catch

var above: bool = false
var climbing: bool = false
var hanging: bool:
	get: return above and climbing

func _decide_moving() -> void:
	if hanging: catch.ledge()

func move_above(_execute: TileMapLayer) -> void:
	above = true
	if above and catch.hero_in_midair():
		catch.ledge_in_midair()
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
		catch.encounter_ledge(false)

func process_physics(delta: float) -> void:
	pass
