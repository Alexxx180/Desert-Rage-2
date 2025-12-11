extends Node

@onready var timing: ActionTimer = $timing
@onready var state: Node = $state

func _ready() -> void:
	state.atb.timing = timing
	timing.timeout.connect(tick)
	# timing.start()

func set_direction(motion: Vector2) -> void:
	state.atb.run_start(motion)

func reset_run() -> void:
	state.set_mach(state.MIN)
	timing.start()

func transitions() -> void:
	if state.atb.go:
		state.to_run()
	elif state.walk_transit:
		state.to_walk()

func bar_reset() -> void:
	if state.atb.acting:
		state.reset_mach()
		timing.stop()

func tick() -> void:
	state.atb.increment()
	transitions()
	bar_reset()
