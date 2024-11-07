extends Node

@onready var forward: ActionTimer = $forward
@onready var velocity: Node = $velocity

const FRICTION: float = 0.01

var _weight: float = 1
var weight: float:
	get: return _weight
	set(value):
		assert(value != 0)
		_weight = value

func apply_velocity(next: Vector2) -> void:
	velocity.set_position(next * FRICTION / weight)
	print("VELOCITY NOW: ", velocity.position, "- NO FRICTION: ", next)

	if next == Vector2.ZERO:
		forward.stop()
	elif not forward.is_ticking:
		forward.start()
