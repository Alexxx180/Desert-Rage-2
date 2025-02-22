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

func _push_forward(next_weight: int) -> void:
	_weight = next_weight
	hero.pushing = _weight != 0

func start_forward(box: CharacterBody2D) -> void:
	box.logic.processors.grab_box(self)
	_push_forward(_weight + box.weight)

func stop_forward(box: CharacterBody2D) -> void:
	box.logic.processors.release_box(self)
	_push_forward(_weight - box.weight)
