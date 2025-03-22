extends Node

@onready var feet: Node = $feet

func controls(hero: CharacterBody2D, jump: Node) -> void:
	# overview controls...
	var platforming: Node2D = hero.logic.detectors.platforming
	var ledges: Area2D = platforming.platforms.ledges

	jump.feet.dash.connect(hero.dash)
	jump.feet.teleport.connect(hero.teleport)

	jump.ledges.space.same_floor = jump.feet.same_floor
	jump.ledges.space.setup(hero)

	ledges.area_entered.connect(jump.ledges.append)
	ledges.area_exited.connect(jump.ledges.remove)

	feet.controls(hero, jump.feet, platforming)
