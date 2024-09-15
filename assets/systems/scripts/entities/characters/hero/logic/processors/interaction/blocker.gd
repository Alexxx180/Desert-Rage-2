extends Timer

signal rollback()
signal recoil(mode: ProcessMode)

const GAP: int = 2

var is_pushing: bool = false
var mode: ProcessMode = Processors.wont

func is_close(distance: float) -> bool:
	is_pushing = distance < GAP
	return is_pushing

func _contact(feedback: Callable) -> void:
	recoil.emit(mode)
	feedback.call()

func _come_off() -> void:
	mode = Processors.wont
	_contact(stop)

func stop_impulse() -> void:
	if is_pushing:
		mode = Processors.will
		_contact(start)
		rollback.emit()
		is_pushing = false

func is_contact() -> bool:
	return mode == Processors.wont
