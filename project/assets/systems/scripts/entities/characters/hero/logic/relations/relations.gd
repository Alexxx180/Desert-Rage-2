extends Node

@onready var environment: Node = $environment
@onready var input: Node = $input
@onready var stats: Node = $stats

func controls(hero: CharacterBody2D) -> void:
	var processors: Node = hero.logic.processors

	stats.controls(hero, hero.logic.stats)
	environment.controls(hero, processors.environment)
	input.set_control(hero, processors.input)
