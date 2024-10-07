extends Node

var walking: bool = true

func tick(blackboard: Node) -> void:
	const act: String = "run"

	if Prompters.toggle(act):
		blackboard.timing.start()
		blackboard.accelerate.emit(blackboard.RUN)

	if Prompters.release(act):
		# TODO - DASH IMPLEMENTATION:
		# walking = not walking or blackboard.timing.finished
		walking = not (blackboard.timing.finished and walking)
		blackboard.walk(walking)
