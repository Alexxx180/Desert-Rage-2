extends Node

signal moving(velocity: Vector2)
signal travel(motion: Vector2)
signal platforming(motion: Vector2)

@onready var run: Node = $run
# @onready var teleport: Node = $platform

var levels: Node
var actions: Node
var hanging: bool = false

func set_hanging(chains: Node) -> void:
	hanging = chains.hanging

func move_hanging(motion: Vector2) -> void:
	if motion != Vector2.ZERO:
		levels.jump.perform(motion)
	if levels.jump.feet.stable:
		travel.emit(motion) # teleport.travel(motion)

func _feedback(motion: Vector2) -> void:
	run.set_direction(motion)
	if not hanging: # print("perform right after: ", motion)
		move_hanging(motion)
	else:
		platforming.emit(motion) # teleport.platforming(motion)
	actions.tick() # TEMP disable fox jump box check

func turn_around(target_motion: Vector2) -> void:
	if not levels.jump.jumped:
		moving.emit(target_motion) # print("MOTION: ", target_motion)
		_feedback(target_motion)
