extends Node

@onready var forward: ActionTimer = $forward
@onready var box: Node = $direction

var _impulse: float
var impulse: float:
	get: return _impulse

func start_forward(target: Vector2i, force: float) -> void:
	box.set_direction(target)
	_impulse = force
	forward.start()

func stop_forward() -> void:
	forward.stop()
