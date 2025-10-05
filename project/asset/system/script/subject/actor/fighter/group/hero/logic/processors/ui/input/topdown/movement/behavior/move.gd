extends Node

signal moving(velocity: Vector2)

@onready var run: Node = $run
@onready var velocity: Node = $velocity
@onready var teleport: Node = $teleport

func process_physics(delta: float) -> void:
	run.process_physics(delta)

func turn_around(target_motion: Vector2) -> void:
	moving.emit(target_motion)
	run.set_direction(target_motion)
	velocity.make_velocity(target_motion)
