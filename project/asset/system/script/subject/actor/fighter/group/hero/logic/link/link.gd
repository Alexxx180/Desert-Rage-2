extends Node

@onready var input: Node = $input
@onready var inventory: Node = $inventory
@onready var world: Node = $world
@onready var stats: Node = $stats

func controls(hero: CharacterBody2D) -> void:
	var work: Node = hero.logic.work
	hero.view.animation.moves.hero = hero
	input.controls(hero, work.input)
	inventory.controls(hero, work.world.inventory)
	world.controls(hero, work.world)
	stats.controls(hero, work.stats)
