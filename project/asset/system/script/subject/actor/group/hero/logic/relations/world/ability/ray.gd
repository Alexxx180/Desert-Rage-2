extends Node

@onready var fire: Node = $fire

func controls(hero: CharacterBody2D, ability: Node, activators: Node) -> void:
	fire.controls(hero, ability.fire, activators.freeze)
