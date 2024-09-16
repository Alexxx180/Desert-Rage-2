extends RefCounted

class_name ActionTimer

const FINISH: int = 0

var _period: float = 0

var _press_time: float = 0
var press_time: float:
	get: return _press_time

func _init(period: float = 0.05) -> void:
	_period = period

func play(delta: float) -> void:
	if _press_time > FINISH: _press_time -= delta

func restart() -> void:
	_press_time = _period

func finished() -> bool:
	return press_time <= FINISH
