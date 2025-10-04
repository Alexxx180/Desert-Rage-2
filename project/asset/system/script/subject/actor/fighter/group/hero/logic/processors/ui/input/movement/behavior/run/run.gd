extends Node

@onready var timing: ActionTimer = $timing
@onready var state: Node = $state

func _ready() -> void: timing.timeout.connect(tick)

func set_direction(motion: Vector2) -> void:
	if state.is_run_start(motion): timing.start()

func reset_run() -> void:
	state.set_mach(state.MIN)
	timing.start()

func transitions() -> void:
	if state.run_transit():
		state.to_run()
	elif state.walk_transit():
		state.to_walk()

func bar_reset() -> void:
	if state.strict_action():
		state.reset_mach()
		timing.stop()

func tick() -> void:
	state.set_atb_mach()
	transitions()
	bar_reset()
