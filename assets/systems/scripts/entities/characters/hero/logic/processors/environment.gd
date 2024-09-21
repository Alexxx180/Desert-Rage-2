extends Node

@onready var surface: Node = $surface

func set_control_entity(hero: CharacterBody2D) -> void:
	surface.set_control_entity(hero)
