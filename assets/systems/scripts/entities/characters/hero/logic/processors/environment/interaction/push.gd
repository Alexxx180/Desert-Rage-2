extends Node

signal apply_velocity(velocity: Vector2)

var _impulse: float = 1
var _velocity: Vector2 = Vector2.ZERO

func set_velocity(velocity: Vector2) -> void:
	apply_velocity.emit(velocity * _impulse)
	_velocity = velocity

func set_impulse(impulse: float) -> void:
	_impulse = impulse
	#print("SET IMPULSE TO: ", impulse)

func start_forward(box: CharacterBody2D) -> void:
	var push: Node = box.logic.processors.movement.push
	apply_velocity.connect(push.apply_velocity)
	#apply_impulse.connect(push.apply_impulse)
	#push.apply_velocity(_velocity * _impulse)

func stop_forward(box: CharacterBody2D) -> void:
	var push: Node = box.logic.processors.movement.push
	apply_velocity.disconnect(push.apply_velocity)
	#apply_impulse.disconnect(push.apply_impulse)
	push.apply_velocity(Vector2.ZERO)
