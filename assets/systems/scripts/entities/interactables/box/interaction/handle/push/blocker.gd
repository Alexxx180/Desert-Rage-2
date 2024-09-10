extends Timer

var transporter: Node
var is_pushing: bool = false

@onready var walls: StaticBody2D = $walls

func check_distance(distance: float) -> void:
	is_pushing = distance < transporter.GAP

func _switch_contact(mode: ProcessMode, feedback: Callable) -> void:
	walls.process_mode = mode
	feedback.call()

func _come_off() -> void:
	_switch_contact(Node.PROCESS_MODE_DISABLED, stop)

func stop_impulse() -> void:
	if is_pushing:
		_switch_contact(Node.PROCESS_MODE_INHERIT, start)
		transporter.rollback_position()
		is_pushing = false

func is_contact() -> bool:
	return walls.process_mode != Node.PROCESS_MODE_INHERIT
