extends Node

@onready var hero: Node = $direction
@onready var push: Node = $impulse

func start_forward(box: StaticBody2D) -> void:
	#print("BOX FORWARDING..")
	box.logic.processors.movement.push.start_forward(hero.direction, push.impulse)

func stop_forward(box: StaticBody2D) -> void:
	#print("BOX STOP FORWARDING..")
	box.logic.processors.movement.push.stop_forward()
