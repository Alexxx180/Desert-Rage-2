extends Node

@onready var forward: ActionTimer = $forward
@onready var box: Node = $direction

#var _impulse: float
#var impulse: float:
#	get: return _impulse

func start_forward(target: Vector2, force: float) -> void:
	box.set_velocity(target * force)
	#_impulse = force
	forward.start()

func stop_forward() -> void:
	forward.stop()
