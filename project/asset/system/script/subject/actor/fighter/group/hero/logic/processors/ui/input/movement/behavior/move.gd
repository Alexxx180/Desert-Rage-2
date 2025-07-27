extends Node

signal moving(velocity: Vector2)
signal controlling(velocity: Vector2)
signal move(velocity: Vector2)

var behavior: Node
var motion: Vector2 = Vector2.ZERO
var _walk: bool = true

func reset() -> void: motion = Vector2.ZERO

func walk(condition: bool) -> void:
	if condition:
		_walk = condition
		behavior.run.to_walk()

func process_physics(delta: float) -> void:
	move.emit(delta * motion)
	walk(not _walk)

func turn_around(target_motion: Vector2) -> void:
	moving.emit(target_motion)
	behavior.run.tick()
