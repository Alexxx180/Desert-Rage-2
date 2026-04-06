extends Timer

var state: SpeedRangeATB = SpeedRangeATB.new()
var timing: ActionTimer = ActionTimer.new()

func _physics_process(delta: float) -> void:
	timing.play(delta)

func _ready() -> void:
	state.atb.walking = self
	timing.timeout.connect(tick)
	timeout.connect(state.atb.walk)
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
	if state.atb.acting or state.atb.stand:
		state.reset_mach()
		timing.stop()

func tick() -> void:
	state.atb.increment()
	transitions()
	bar_reset()
