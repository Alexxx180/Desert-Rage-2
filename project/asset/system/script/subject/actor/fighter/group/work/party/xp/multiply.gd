extends Timer

signal update_meter(time: float, maximum: float)
signal update_x(multiplier: float)
signal finish()

const MAX: int = 1.0 # Progress to 2-3 with hero sum of reaction later
const BASE: int = 1.0

@onready var delay: Timer = $delay

var drop: Dictionary = Skills.drop
var multiplier: Dictionary = Skills.multiplier
var last: Vector2 = Vector2.ONE
var duration: float = MAX

func _ready() -> void:
	timeout.connect(meter_feedback)
	delay.timeout.connect(_start_timer)

func stop_meter() -> void:
	stop()
	last.y = BASE
	finish.emit()
	duration = MAX

func meter_feedback() -> void:
	duration -= wait_time
	update_combo_meter()
	if duration <= 0:
		stop_meter()

func _update() -> void:
	update_multiplier()
	update_combo_meter()

func update_combo_meter() -> void:
	update_meter.emit(duration, MAX)

func update_multiplier() -> void:
	update_x.emit(last.y)

func by_slots(slots: int) -> void:
	if multiplier[slots] > last.y:
		last = Vector2(slots, multiplier[slots])
	_update()
	_start_delay()
	# start()

func _start_timer() -> void:
	start()

func _start_delay() -> void:
	stop()
	delay.start()

func hit() -> void:
	if last.y <= BASE: return
	duration = MAX
	last.y -= drop[int(last.x)]
	if last.y <= BASE:
		stop_meter()
	else:
		update_multiplier()
		_start_delay()
