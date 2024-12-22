extends Node

@onready var floors: Node = $floors
@onready var push: Node = $push
@onready var pull: Node = $pull

func controls(hero: CharacterBody2D, environment: Node) -> void:
	var platforming: Node = hero.logic.detectors.platforming

	floors.controls(hero, environment.floors, platforming.floors)
	push.controls(hero, environment.interaction.push)
	pull.controls(hero, environment.interaction.pull)
