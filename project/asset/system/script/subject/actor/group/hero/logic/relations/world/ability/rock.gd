extends Node

@onready var rain: Node = $rain

func controls(hero: CharacterBody2D, ability: Node, activators: Node) -> void:
	rain.controls(hero, ability.rain, activators.ability.puddle.rain)
