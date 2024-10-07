extends Node

@onready var hero: Node = $direction
@onready var push: Node = $impulse

func forward(box: StaticBody2D) -> void:
	print("IT IS WORKING")
	box.push(hero.direction * push.impulse)
