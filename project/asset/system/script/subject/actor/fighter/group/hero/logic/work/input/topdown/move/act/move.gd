extends Node

signal moving(velocity: Vector2)

@onready var run: Node = $run
@onready var velocity: Node = $velocity
@onready var teleport: Node = $teleport

var levels: Node
var actions: Node

func process_physics(delta: float) -> void:
	pass # run.process_physics(delta)

func _feedback(motion: Vector2) -> void:
	run.set_direction(motion)
	velocity.travel(motion)
	levels.jump.perform(motion)
	actions.tick()

func turn_around(target_motion: Vector2) -> void:
	moving.emit(target_motion) # print("MOTION: ", target_motion)
	if not levels.jump.jumped:
		_feedback(target_motion)
