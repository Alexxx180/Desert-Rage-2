extends Node

@onready var fire: Node = $fire

func controls(hero: CharacterBody2D, ability: Node, behavior: Node) -> void:
	fire.controls(hero, ability.fire, behavior.ability.freeze)
