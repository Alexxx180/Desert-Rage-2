extends Node

@onready var environment: Node = $environment
@onready var platforming: Node = $platforming
@onready var interaction: Node = $interaction
@onready var input: Node = $input
@onready var stats: Node = $stats

func apply(hero: CharacterBody2D) -> void:
	var detectors: Node = hero.logic.detectors
	var processors: Node = hero.logic.processors

	hero.logic.processors.input.directing.connect(detectors.interaction.set_direction)
	hero.logic.processors.input.directing.connect(detectors.platforming.floors.set_direction)

	platforming.set_control(hero)
	environment.set_control(processors.environment, hero)
	input.set_control(hero, processors.input)
	interaction.set_control(detectors.interaction, processors.environment)
	stats.set_control(hero, hero.logic.stats)
