extends Node

@onready var surface: Node = $surface
@onready var push: Node = $push

func set_control(environment: Node, hero: CharacterBody2D) -> void:
	surface.set_control(environment.surface, hero)
	push.set_control(environment.interaction.push, hero.logic.stats)
