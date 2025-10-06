extends Node

signal moving(velocity: Vector2)

@onready var run: Node = $run
@onready var velocity: Node = $velocity
@onready var teleport: Node = $teleport

func process_physics(delta: float) -> void:
	pass
	# run.process_physics(delta)

func turn_around(target_motion: Vector2) -> void:
	print("MOTION: ", target_motion)
	moving.emit(target_motion)
	run.set_direction(target_motion)
	velocity.travel(target_motion)
