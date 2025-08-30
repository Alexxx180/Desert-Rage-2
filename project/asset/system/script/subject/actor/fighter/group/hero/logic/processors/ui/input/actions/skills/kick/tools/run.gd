extends BehaviorAction

enum { WALK = 1, RUN = 2 }

signal accelerate(mach: int)

var walking: bool = true
var behavior: Node

func to_walk() -> void:
	accelerate.emit(WALK)

func tick(mark: Tick) -> int: # const act: String = "run"
	var kick: Dictionary = mark.blackboard.get_value("kick")
	if kick.toggled:
		behavior.timing.start()
		accelerate.emit(RUN)

	if kick.release:
		# TODO - DASH IMPLEMENTATION:
		# walking = not walking or blackboard.timing.finished
		walking = not (behavior.timing.finished and walking)
		behavior.move.walk(walking)
	return OK
