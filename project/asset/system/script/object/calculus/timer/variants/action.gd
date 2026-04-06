class_name ActionTimer extends RefCounted

signal timeout()

@export var period: float = 0.05

var _ticking: bool = false
var is_ticking: bool:
	get: return _ticking

var _time_left: float = 0
var time_left: float:
	get: return _time_left

func restart() -> void:
	_time_left = period

func _play(delta: float) -> bool:
	_time_left -= delta
	return _time_left <= 0

func play(delta: float) -> void:
	if not _ticking: return
	if _play(delta):
		restart()
		timeout.emit()

func stop() -> void: _ticking = false
func start() -> void:
	_ticking = true
	restart()
