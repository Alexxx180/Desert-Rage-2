extends Node

enum { STAND = -1, WALK = 1, RUN = 2, DELAY = 5, MIN = 0, ACTION = 20, MACH = 35, MAX = 40 }

signal accelerate(mach: int)
signal new_mach(next: int)
signal stop_mach()

var walking: bool = true
var behavior: Node
var mach: Vector2i = Vector2i(ACTION, MIN)

@export var available_bar: bool = true
@onready var timing: ActionTimer = $timing

func set_direction(motion: Vector2) -> void:
	mach.y = STAND if motion == Vector2.ZERO else WALK
	if mach.x == ACTION and mach.y != STAND:
		timing.start()

func set_mach(next: int) -> void:
	mach.x = next
	new_mach.emit(next)

func to_walk() -> void:
	accelerate.emit(WALK)

func reset_run() -> void:
	set_mach(MIN)
	timing.start()

func _ready() -> void:
	timing.timeout.connect(tick)

func _set_running() -> void:
	walking = false
	accelerate.emit(RUN)

func _set_walking() -> void:
	# walking = not walking or blackboard.timing.finished
	walking = true
	behavior.move.walk(walking)

func is_delayed(next) -> bool:
	return available_bar and next >= DELAY

func tick() -> void:
	# const act: String = "run"
	set_mach(clampi(mach.x + mach.y, ACTION, MAX) if mach.x >= ACTION else (mach.x + 1))
	# print("MACH X: ", mach.x)
	
	if mach.x == MACH:
		_set_running()
	elif not walking and mach.x < MACH:
		_set_walking()

	if mach.x == ACTION and mach.y == STAND:
		stop_mach.emit()
		timing.stop()
