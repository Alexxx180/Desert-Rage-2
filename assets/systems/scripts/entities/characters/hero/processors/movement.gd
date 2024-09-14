extends Node

signal move(delta: float)
signal accelerate(mach: int)

enum STATE { WALK = 1, RUN = 2 }

const PERIOD: float = 0.05

var press_time: float = 0
var walk: bool = true

func _physics_process(delta):
	move.emit(delta)

	if press_time > 0:
		press_time -= delta
	if not walk:
		walk = true
		accelerate.emit(STATE.WALK)

func _input(_event: InputEvent):
	const act: String = "run"

	if Processors.toggle(act):
		press_time = PERIOD
		accelerate.emit(STATE.RUN)
	if Processors.release(act):
		walk = press_time >= 0
		if walk: accelerate.emit(STATE.WALK)
