class_name RangeATB extends RefCounted

signal show(portion: float)

enum { STAY = -1, WALK = 1, DROP = -3 }
enum { ACTION = -100, STAND = 0, GO = 40, MAX = 50 }

var direction: int = 0
var value: int = 0

var acting: bool = false # :
	#get: return value <= STAND# and direction != WALK
var stand: bool:
	get: return value == STAND
var go: bool:
	get: return value >= GO

# var timing: ActionTimer
var walking: Timer

func set_mach(next: int) -> void:
	value = next# ; print("MACH: ", value)
	if value < 0:
		show.emit(abs(value) / float(abs(ACTION)))

func lower(power: int) -> int:
	return clampi(value + power, ACTION, MAX)

func decrement() -> void:
	acting = true
	set_mach(lower(DROP))
	walking.start()

func walk() -> void:
	acting = false
	walking.timing.start()

func increment() -> void: #  print("direction: ", direction)
	if value < STAND:
		set_mach(lower(WALK))
	elif value >= STAND:
		set_mach(lower(direction))

func run_start(motion: Vector2) -> void:
	direction = STAY if motion == Vector2.ZERO else WALK
	if not walking.timing.is_ticking and direction == WALK: # not acting and 
		walking.timing.start() # not acting and 
	# acting = false
