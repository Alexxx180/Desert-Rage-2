extends Node

@onready var processors: Node = $processors
@onready var stats: Node = $stats

func controls(hero: CharacterBody2D) -> void:
	stats.controls(hero, hero.logic.stats)
	processors.controls(hero, hero.logic.processors)
