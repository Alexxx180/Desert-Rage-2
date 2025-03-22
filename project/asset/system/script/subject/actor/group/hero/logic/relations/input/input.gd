extends Node

@onready var platforming: Node = $platforming
@onready var movement: Node = $movement

func controls(hero: CharacterBody2D, input: Node) -> void:
	var detectors: Node2D = hero.logic.detectors
	var surface: Node2D = detectors.platforming.platforms.surface
	var space: Node = input.platforming.jump.ledges.space
	var deployment: DeploymentRaycast = surface.deployment
	print ("DEPLOYMENT GET")

	input.moving.connect(input.movement.face.set_position)
	input.moving.connect(hero.view.animation.move)

	movement.controls(hero, input.movement)
	platforming.controls(hero, input.platforming)

	# directing
	input.moving.connect(surface.overleap.gap.set_direction)
	input.moving.connect(surface.overleap.upland.set_direction)

	input.moving.connect(surface.deployment.walls.set_direction)
	input.moving.connect(surface.deployment.ground.set_direction)
	input.moving.connect(space.set_direction)
	input.moving.connect(deployment.set_direction)

	input.moving.connect(detectors.world.set_direction)
	input.moving.connect(detectors.platforming.floors.set_direction)

	# hero.logic.processors.environment
	# input.directing.connect(environment.surface.tracking.map.set_direction)
