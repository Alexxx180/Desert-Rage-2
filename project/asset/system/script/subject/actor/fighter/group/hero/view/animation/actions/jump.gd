extends Node

var moves: Node

func _switch_monitoring(sequence_ended: bool) -> void:
	var platforms: Node2D = moves.hero.logic.detectors.platforming.platforms
	platforms.surface.overleap.turn_monitoring(sequence_ended)

func _set_input(processors: Node, started_sequence: bool) -> void:
	var input: Node = processors.ui.input
	var feet: Node = input.platforming.jump.feet
	
	input.platforming.jump.jumped = started_sequence
	input.gravity.during_jump(started_sequence, feet.stable)

	if !started_sequence: input.movement.type.velocity.forget_velocity()
	processors.freeze_input[started_sequence].call()

func sequence(started: bool) -> void:
	_set_input(moves.hero.logic.processors, started)
	_switch_monitoring(!started)
#	else: for state in [true, false]: hero.set_hero_collision(true)

func stop_dash() -> void:
	var temp: Vector2i = moves.tree.direction
	sequence(false)
	moves.set_move_action("go")
	moves.set_hang_move("go")
	moves.tree.direction = temp
	print("DASH STOPPED")
