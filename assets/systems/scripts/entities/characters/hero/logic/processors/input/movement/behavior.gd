extends Node

func tick(blackboard: Node) -> void:
	const act: String = "run"

	if Prompters.toggle(act):
		blackboard.timing.restart()
		blackboard.accelerate.emit(blackboard.RUN)

	if Prompters.release(act):
		blackboard.walk(not blackboard.timing.finished())
