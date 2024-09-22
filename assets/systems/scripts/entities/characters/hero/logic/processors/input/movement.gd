extends Node

signal move(delta: float)
signal accelerate(mach: int)

enum { WALK = 1, RUN = 2 }

var _timing: ActionTimer = ActionTimer.new(0.05)
var _walk: bool = true

func walk(condition: bool) -> void:
	if condition:
		_walk = condition
		accelerate.emit(WALK)

func _physics_process(delta) -> void:
	move.emit(delta)
	_timing.play(delta)
	walk(not _walk)

func _input(_event: InputEvent):
	const act: String = "run"

	if Prompters.toggle(act):
		_timing.restart()
		accelerate.emit(RUN)

	if Prompters.release(act):
		walk(not _timing.finished())
