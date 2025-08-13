extends Node

var input: Node

func access(motion: Vector2) -> void:
	if input.platforming.jump.animation: return
	input.movement.behavior.move.turn_around(motion)
	input.movement.behavior.move.motion = Vector2(motion.x, 0)
	input.actions.tick(self, input.board) # TEMP disable for jumping

func process_physics(delta: float) -> void:
	input.movement.behavior.move.process_physics(delta)

func on_select() -> void:
	var motion: Vector2 = Vector2(input.motion.x, 0)
	#input.gravity.turn_walls_collision(false) # FOR WHIP
	input.movement.type.velocity.forget_velocity()
	input.movement.behavior.move.turn_around(motion)
	input.movement.behavior.move.motion = motion
