extends Node

@onready var jump: Node = $jump
@onready var input: Node = $input

func set_control_entity(hero: CharacterBody2D) -> void:
	input.set_control_entity(hero)
	jump.set_control_entity(hero)
