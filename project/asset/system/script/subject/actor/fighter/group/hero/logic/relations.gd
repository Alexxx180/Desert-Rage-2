extends Node

@onready var input: Node = $input
@onready var world: Node = $world
@onready var stats: Node = $stats

func controls(hero: CharacterBody2D) -> void:
	var processor: Node = hero.logic.processors
	input.controls(hero, processor.ui.input)
	world.controls(hero, processor.world)
	stats.controls(hero, processor.stats)
