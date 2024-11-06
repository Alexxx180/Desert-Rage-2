extends Node

@onready var hero: Node = $velocity
@onready var push: Node = $impulse

func start_forward(box: CharacterBody2D) -> void:
	#print("BOX FORWARDING..")
	box.logic.processors.movement.push.start_forward(hero.position, push.impulse)

func stop_forward(box: CharacterBody2D) -> void:
	#print("BOX STOP FORWARDING..")
	box.logic.processors.movement.push.stop_forward()
