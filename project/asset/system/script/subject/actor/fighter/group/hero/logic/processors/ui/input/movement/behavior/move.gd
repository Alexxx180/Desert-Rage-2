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
	for action in ["action", "run", "skill_one", "skill_two"]:
		if Input.is_action_just_pressed(action):
			behavior.run.reset_run()
	
	move.emit(delta * motion)
	walk(not _walk)

func turn_around(target_motion: Vector2) -> void:
	moving.emit(target_motion)
	behavior.run.set_direction(target_motion)
	# behavior.run.tick()
