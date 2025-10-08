extends Node

@onready var chains: Node = $chains
@onready var spring: Node = $spring

func controls(hero: CharacterBody2D, tools: Node) -> void:
	chains.controls(hero, tools.chains)
	spring.controls(hero, tools.jump)
