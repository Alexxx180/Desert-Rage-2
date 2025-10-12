extends Node

signal feedback()
signal strength_input(power: float)

const FIXED_POWER: float = 1.0
var _power_count: Vector2

var timed: bool = false
var power: float = 0.0

func reset_time(state: bool) -> void:
	timed = state

func reset_power() -> void:
	_power_count = Vector2.ZERO

func add_power(key: String) -> void:
	_power_count += Vector2(Input.get_action_strength(key), 1)

func calculate_power(fixed: bool) -> void:
	power = FIXED_POWER if fixed else _power_count.x / _power_count.y

func touch(action: bool) -> void: timed = timed and action

func press(available: bool, key: String) -> void:
	if available:
		add_power(key)
	else:
		touch(Input.is_action_pressed(key))

func give_feedback(powered: bool) -> void:
	if not timed: return
	if powered:
		strength_input.emit(power)
	else:
		feedback.emit()
