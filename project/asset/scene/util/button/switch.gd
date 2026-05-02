class_name ActionsSwitch extends RefCounted

signal feedback()
signal strength_input(power: float)

const FIXED_POWER: float = 1.0

var timed: bool = false
var power: float = 0.0

func reset_time(state: bool) -> void: timed = state

func reset_power() -> void: power = 0

func set_power(fixed: bool, key: String) -> void:
	power = FIXED_POWER if fixed else Input.get_action_strength(key)

func touch(action: bool) -> void: timed = timed and action

func give_feedback(powered: bool) -> void:
	if not timed: return
	if powered:
		strength_input.emit(power)
	else:
		feedback.emit()
