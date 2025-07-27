extends Node

var input: Node

func access(motion: Vector2) -> void:
	if input.platforming.jump.animation: return
	input.platforming.jump.perform()
	input.movement.behavior.move.turn_around(motion)
	input.movement.behavior.move.motion = motion
	input.actions.tick(self, input.board)

func process_physics(delta: float) -> void:
	input.movement.behavior.move.process_physics(delta)

func on_select() -> void: pass
