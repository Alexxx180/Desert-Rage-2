extends Node

signal apply_velocity(velocity: Vector2)
signal apply_impulse(impulse: float)

@onready var hero: Node = $velocity
#@onready var _push: Node = $impulse

func set_velocity(velocity: Vector2) -> void:
	print("VELOCITY IS: ", velocity)
	apply_velocity.emit(velocity)

func set_impulse(impulse: float) -> void:
	apply_impulse.emit(impulse)

func start_forward(box: CharacterBody2D) -> void:
	#print("BOX FORWARDING..")
	var push: Node = box.logic.processors.movement.push
	apply_velocity.connect(push.apply_velocity)
	apply_impulse.connect(push.apply_impulse)
	#box.logic.processors.movement.push.start_forward(hero.position, push.impulse)

func stop_forward(box: CharacterBody2D) -> void:
	#print("BOX STOP FORWARDING..")
	#box.logic.processors.movement.push.stop_forward()
	var push: Node = box.logic.processors.movement.push
	apply_velocity.disconnect(push.apply_velocity)
	apply_impulse.disconnect(push.apply_impulse)
	push.apply_velocity(Vector2.ZERO)
