extends Node

var input: Node

@onready var movement: Node = $movement
@onready var platforming: Node = $platforming
@onready var actions: Node = $actions

func access(motion: Vector2) -> void:
	if input.platforming.jump.jumped: return
	input.platforming.jump.perform(motion)
	input.movement.behavior.move.turn_around(motion)
	input.movement.behavior.move.motion = motion
	input.actions.tick(self, input.board)

func process_physics(delta: float) -> void:
	if input.movement.mode.hero.logic.work.input.platforming.jump.feet.stable:
		input.movement.behavior.move.process_physics(delta)
	else:
		print("HERO ON THE BOX")

func on_select() -> void: pass
