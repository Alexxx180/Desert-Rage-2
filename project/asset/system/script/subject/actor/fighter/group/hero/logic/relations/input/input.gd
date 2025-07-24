extends Node

@onready var platforming: Node = $platforming
@onready var movement: Node = $movement

func controls(hero: CharacterBody2D, input: Node) -> void:
	var detectors: Node2D = hero.logic.detectors
	var surface: Node2D = detectors.platforming.platforms.surface
	var space: Node = input.platforming.jump.ledges.space
	var deployment: DeploymentRaycast = surface.deployment
	print ("DEPLOYMENT GET")

	input.movement.controlling.connect(input.movement.face.set_position)
	input.movement.moving.connect(hero.view.animation.move)
	input.movement.moving.connect(hero.view.ap.set_direction)
#	hero.action_move.connect(hero.view.animation.action_move)

	movement.controls(hero, input.movement)
	platforming.controls(hero, input.platforming)

	# directing
	input.movement.moving.connect(surface.overleap.gap.set_direction)
	input.movement.moving.connect(surface.overleap.upland.set_direction)

	input.movement.moving.connect(surface.deployment.walls.set_direction)
	input.movement.moving.connect(surface.deployment.ground.set_direction)
	input.movement.moving.connect(space.set_direction)
	input.movement.moving.connect(deployment.set_direction)

	input.movement.moving.connect(detectors.set_direction)
	input.movement.moving.connect(detectors.platforming.floors.set_direction)
	
	input.actions.check.action.connect(func():
		hero.view.animation.moves.set_fight_start("active")
		hero.view.animation.moves.set_fighting("hands"))

	input.actions.check.skill_two.connect(
		hero.logic.processors.ui.input.platforming.pillar.dash_on_whip)

	input.actions.check.kick.connect(func():
		hero.view.animation.moves.set_fight_start("active")
		hero.view.animation.moves.set_fighting("legs"))

	# hero.logic.processors.environment
	# input.directing.connect(environment.surface.tracking.map.set_direction)
