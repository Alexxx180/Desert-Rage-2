extends Node

func controls(hero: CharacterBody2D, move: Node) -> void:
	print("CONNECT MOVEMENT")
	hero.logic.work.world.layers.hero = hero
	move.hero = hero
	var see: Node2D = hero.logic.see
	var space: Node = hero.logic.work.input.topdown.levels.jump.ledges.space
	var surface: Node2D = hero.logic.see.levels.platforms.surface
	var deploy: DeploymentRaycast = surface.deployment
	
	move.act.moving.connect(hero.view.animation.move)
	move.act.moving.connect(hero.view.ap.set_direction)

	move.act.moving.connect(deploy.walls.set_direction)
	move.act.moving.connect(deploy.ground.set_direction)
	move.act.moving.connect(deploy.set_direction)
	move.act.moving.connect(space.set_direction)

	move.act.moving.connect(see.set_direction)
	move.act.moving.connect(see.levels.floors.set_direction)
	
	# movement.behavior.move.move.connect(hero.logic.work.input.move.type.velocity.travel)
	# movement.behavior.run.accelerate.connect(hero.logic.stats.accelerate)
	# movement.behavior.run.accelerate.connect(hero.view.animation.moves.set_walk_speed)
