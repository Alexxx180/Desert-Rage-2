extends Node

@onready var input: Node = $input
@onready var environment: Node = $environment

func set_control_entity(hero: CharacterBody2D) -> void:
	input.set_control_entity(hero)
	environment.set_control_entity(hero)
