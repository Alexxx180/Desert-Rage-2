extends Node

@onready var forward: ActionTimer = $forward
@onready var velocity: Node = $velocity

var _impulse: float = 1

func apply_impulse(impulse: float) -> void:
	_impulse = impulse

func apply_velocity(v: Vector2) -> void:
	velocity.set_position(v)
	if v == Vector2.ZERO:
		print("STOP")
		forward.stop()
	elif not forward.is_ticking:
		print("START")
		forward.start()

#func start_forward(target: Vector2, force: float) -> void:
#	print("START")
#	print("SET VELOCITY: ", target, "FORCE: ", force)
#	velocity.set_position(target * force)
#	forward.start()

#func stop_forward() -> void:
#	print("STOP")
#	forward.stop()
