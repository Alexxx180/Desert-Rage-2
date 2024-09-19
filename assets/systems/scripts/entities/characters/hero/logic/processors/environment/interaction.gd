extends Node

@onready var push: Node = $push

func set_control_entity(hero: CharacterBody2D) -> void:
	push.set_control_entity(hero)
