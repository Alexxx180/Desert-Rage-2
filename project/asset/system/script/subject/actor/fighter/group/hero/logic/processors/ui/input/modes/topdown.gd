extends Node

var input: Node

func access(motion: Vector2) -> void:
	if input.platforming.jump.jumped: return
	input.platforming.jump.perform(motion)
	input.movement.behavior.move.turn_around(motion)
	input.movement.behavior.move.motion = motion
	input.actions.tick(self, input.board)

func process_physics(delta: float) -> void:
	if input.movement.mode.hero.logic.processors.ui.input.platforming.jump.feet.balance.stable:
		input.movement.behavior.move.process_physics(delta)
	else:
		print("HERO ON THE BOX")

func on_select() -> void: pass
