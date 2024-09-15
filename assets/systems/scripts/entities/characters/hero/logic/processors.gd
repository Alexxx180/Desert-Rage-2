extends Node

@onready var input: Node = $input

func set_control_entity(hero: CharacterBody2D) -> void:
	input.set_control_entity(hero)
