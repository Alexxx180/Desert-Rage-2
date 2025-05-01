extends OSTPlayer

@onready var timing: Timer = $timer

func stop_timing() -> void:
	timing.stop()
	super.stop_timing()

func start_timing() -> void: timing.start()
