extends Node

@onready var platforming: Node = $platforming
@onready var movement: Node = $movement

func controls(hero: CharacterBody2D, input: Node) -> void:
	var detectors: Node2D = hero.logic.detectors
	var surface: Node2D = detectors.platforming.platforms.surface
	var eyes: Node = input.platforming.jump.overview.directions.eyes

	input.moving.connect(input.movement.face.set_position)
	input.moving.connect(hero.view.animation.move)

	movement.controls(hero, input.movement)
	platforming.controls(hero, input.platforming)

	input.directing.connect(surface.overleap.gap.set_direction)
	input.directing.connect(surface.overleap.upland.set_direction)

	input.directing.connect(surface.deployment.walls.set_direction)
	input.directing.connect(surface.deployment.ground.set_direction)
	input.directing.connect(eyes.set_direction)


	input.directing.connect(detectors.interaction.set_direction)
	input.directing.connect(detectors.platforming.floors.set_direction)

	# hero.logic.processors.environment
	# input.directing.connect(environment.surface.tracking.map.set_direction)
