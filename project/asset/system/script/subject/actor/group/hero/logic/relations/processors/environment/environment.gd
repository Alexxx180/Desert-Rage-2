extends Node

@onready var floors: Node = $floors
@onready var interaction: Node = $interaction

func controls(hero: CharacterBody2D, environment: Node) -> void:
	var platforming: Node = hero.logic.detectors.platforming

	floors.controls(hero, environment.floors, platforming.floors)
	interaction.controls(hero, environment.interaction)
