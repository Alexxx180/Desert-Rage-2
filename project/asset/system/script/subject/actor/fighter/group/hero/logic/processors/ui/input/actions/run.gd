extends Node

enum { WALK = 1, RUN = 2 }

signal accelerate(mach: int)

var walking: bool = true
var behavior: Node

func to_walk() -> void:
	accelerate.emit(WALK)

func tick() -> void:
	const act: String = "run"

	if Prompters.toggle(act):
		behavior.timing.start()
		accelerate.emit(RUN)

	if Prompters.release(act):
		# TODO - DASH IMPLEMENTATION:
		# walking = not walking or blackboard.timing.finished
		walking = not (behavior.timing.finished and walking)
		behavior.move.walk(walking)
