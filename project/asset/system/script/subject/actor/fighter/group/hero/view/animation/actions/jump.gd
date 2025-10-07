extends Node

var moves: Node

func _switch_monitoring(sequence_ended: bool) -> void:
	var platforms: Node2D = moves.hero.logic.see.levels.platforms
	platforms.surface.overleap.turn_monitoring(sequence_ended)

func _set_input(work: Node, started_sequence: bool) -> void:
	var input: Node = work.input
	var feet: Node = input.topdown.levels.jump.feet
	
	input.topdown.levels.jump.jumped = started_sequence
	work.world.layers.during_jump(started_sequence, feet.stable)

	if !started_sequence: input.topdown.move.act.velocity.forget()
	work.freeze_input[started_sequence].call()

func sequence(started: bool) -> void:
	_set_input(moves.hero.logic.work, started)
	_switch_monitoring(!started)
#	else: for state in [true, false]: hero.set_hero_collision(true)

func stop_dash() -> void:
	var temp: Vector2i = moves.tree.direction
	sequence(false)
	moves.set_move_action("go")
	moves.set_hang_move("go")
	moves.tree.direction = temp
	print("DASH STOPPED")
