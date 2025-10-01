extends Node

@onready var feet: Node = $feet

func controls(hero: CharacterBody2D, jump: Node) -> void:
	# overview controls...
	var platforming: Node2D = hero.logic.detectors.platforming
	var ledges: Area2D = platforming.platforms.ledges
	var type: Node = hero.logic.processors.ui.input.movement.type

	jump.feet.dash.connect(type.move.dash)
	jump.feet.teleport.connect(type.move.teleport)

	jump.ledges.space.same_floor = jump.feet.same_floor
	jump.ledges.space.setup(hero)
	jump.ledges.space.floors = jump.feet.floors

	ledges.area_entered.connect(jump.ledges.append)
	ledges.area_exited.connect(jump.ledges.remove)

	feet.controls(hero, jump.feet, platforming)

	jump.surface = platforming.platforms.surface
