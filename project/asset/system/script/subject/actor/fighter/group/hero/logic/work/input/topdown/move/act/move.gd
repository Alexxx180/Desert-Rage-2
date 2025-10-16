extends Node

signal moving(velocity: Vector2)

@onready var run: Node = $run
@onready var velocity: Node = $velocity
@onready var teleport: Node = $teleport

var levels: Node
var actions: Node
var chains: Node

func process_physics(delta: float) -> void:
	pass # run.process_physics(delta)

func _feedback(motion: Vector2) -> void:
	run.set_direction(motion)
	if not chains.hanging:
		# print("perform right after: ", motion)
		if motion != Vector2.ZERO:
			levels.jump.perform(motion)
		if levels.jump.feet.stable:
			velocity.travel(motion)
	else:
		velocity.platforming(motion)
	actions.tick() # TEMP disable fox jump box check

func turn_around(target_motion: Vector2) -> void:
	if not levels.jump.jumped:
		moving.emit(target_motion) # print("MOTION: ", target_motion)
		_feedback(target_motion)
