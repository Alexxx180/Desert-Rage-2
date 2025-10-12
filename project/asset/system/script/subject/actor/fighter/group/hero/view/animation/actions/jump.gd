extends Node

var moves: Node

func _switch_monitoring(sequence_ended: bool) -> void:
	moves.hero.to.platform.surface.border.turn_monitoring(sequence_ended)

func _set_input(topdown: Node, started_sequence: bool) -> void:
	var jump: Node = topdown.levels.jump
	
	jump.jumped = started_sequence
	moves.hero.to.layers.during_jump(started_sequence, jump.feet.stable)

	if !started_sequence:
		topdown.move.act.velocity.forget()
		print("FORGET VELOCITY! ")
	#else:
		#topdown.move.act.run.reset_run()
	# work.freeze_input[started_sequence].call()# IMPORTANT

func sequence(started: bool) -> void:
	moves.tree.effect.sync_animation()
	_set_input(moves.hero.to.topdown, started)
	_switch_monitoring(!started)
#	else: for state in [true, false]: hero.set_hero_collision(true)

func stop_dash() -> void:
	# var temp: Vector2i = moves.tree.direction
	sequence(false)
	moves.set_move_action("go")
	moves.set_hang_move("go")
	# moves.hero.to.topdown.move.act.velocity.forget()
	# moves.tree.direction = temp
	print("DASH STOPPED")

func pull_box(has_boxes: bool) -> void:
	if not moves.hero.to.topdown.levels.jump.jumped:
		moves.set_move_action("pull" if has_boxes else "go")
