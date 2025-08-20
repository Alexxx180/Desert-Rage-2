extends Node

@onready var input: Node = $input
@onready var inventory: Node = $inventory
@onready var world: Node = $world
@onready var stats: Node = $stats

func controls(hero: CharacterBody2D) -> void:
	var processor: Node = hero.logic.processors
	hero.view.animation.moves.hero = hero
	input.controls(hero, processor.ui.input)
	inventory.controls(hero, processor.ui.inventory)
	world.controls(hero, processor.world)
	stats.controls(hero, processor.stats)
