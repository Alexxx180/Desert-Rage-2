extends Node

signal apply_velocity(velocity: Vector2)

var hero: CharacterBody2D
var _impulse: float = 1
var _velocity: Vector2 = Vector2.ZERO
var _weight: int = 0

const FRICTION: float = 0.01

func set_velocity(velocity: Vector2) -> void:
	_velocity = velocity * _impulse * FRICTION / _weight
	apply_velocity.emit(_velocity)
	if hero.pushing:
		hero.velocity = _velocity

func set_impulse(impulse: float) -> void:
	_impulse = impulse
	#print("SET IMPULSE TO: ", impulse)

func start_forward(box: CharacterBody2D) -> void:
	var push: Node = box.logic.processors.movement.push
	apply_velocity.connect(push.apply_velocity)
	_weight += box.weight
	hero.pushing = _weight != 0
	#apply_impulse.connect(push.apply_impulse)
	#push.apply_velocity(_velocity * _impulse)
	#print("start forward: ", _weight)
	#print("start forward")

func stop_forward(box: CharacterBody2D) -> void:
	var push: Node = box.logic.processors.movement.push
	apply_velocity.disconnect(push.apply_velocity)
	_weight -= box.weight
	hero.pushing = _weight != 0
	#apply_impulse.disconnect(push.apply_impulse)
	#print("stop forward: ", _weight)
	#print("stop forward")
	push.apply_velocity(Vector2.ZERO)
