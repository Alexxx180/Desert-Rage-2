extends Node

@onready var feet: Node = $feet

func controls(hero: CharacterBody2D, jump: Node) -> void:
	# overview controls...
	var platforming: Node2D = hero.logic.detectors.platforming
	var ledges: Area2D = platforming.platforms.ledges

	jump.dash.connect(hero.dash)
	jump.teleport.connect(hero.teleport)

	jump.overview.directions.set_directions(hero)

	ledges.area_entered.connect(jump.ledges.append)
	ledges.area_exited.connect(jump.ledges.remove)

	feet.controls(hero, jump.feet, platforming)
