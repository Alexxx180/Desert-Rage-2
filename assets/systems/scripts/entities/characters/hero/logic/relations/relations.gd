extends Node

@onready var environment: Node = $environment
@onready var platforming: Node = $platforming
@onready var interaction: Node = $interaction
@onready var input: Node = $input

func apply(hero: CharacterBody2D) -> void:
	var detectors: Node = hero.logic.detectors
	var processors: Node = hero.logic.processors

	platforming.set_control(detectors.platforming, processors)
	environment.set_control(processors.environment, hero.logic)
	input.set_control(hero, processors.input)
	interaction.set_control(detectors.interaction, processors.environment)

	hero.logic.stats.run.connect(hero.logic.set_velocity)
	hero.logic.stats.size.set_control_entity(hero)
