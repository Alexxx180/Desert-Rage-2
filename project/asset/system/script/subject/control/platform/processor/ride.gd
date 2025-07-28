extends Node

signal forwarding(velocity: Vector2)
signal directing(direction: Vector2)

#@onready var forward: ActionTimer = $forward
#@onready var velocity: Node = $velocity

var _weight: float = 1
var weight: float:
	get: return _weight
	set(value):
		assert(value != 0)
		_weight = value

func apply_velocity(next: Vector2) -> void:
	forwarding.emit(next)
	directing.emit(next.normalized())
