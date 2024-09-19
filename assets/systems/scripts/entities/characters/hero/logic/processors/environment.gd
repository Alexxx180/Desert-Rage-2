extends Node

@onready var interaction: Node = $interaction

func set_control_entity(hero: CharacterBody2D) -> void:
	interaction.set_control_entity(hero)
