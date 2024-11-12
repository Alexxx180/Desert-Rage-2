extends RefCounted

class_name TimerDial

var _time_left: float = 0
var time_left: float:
	get: return _time_left

func restart(period: float) -> void:
	_time_left = period

func play(delta: float) -> bool:
	_time_left -= delta
	return _time_left <= 0
