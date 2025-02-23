extends Node

@onready var input: Node = $input
@onready var world: Node = $world

func controls(hero: CharacterBody2D) -> void:
	var processor: Node = hero.logic.processors
	input.controls(hero, processor.input)
	world.controls(hero, processor.world)
