extends Node

func controls(hero: CharacterBody2D, move: Node) -> void:
	var act: Node = move.act
	var space: Node = hero.to.topdown.levels.jump.ledges.space
	var surface: Node2D = hero.to.platform.surface
	var deploy: DeploymentRaycast = surface.deploy
	
	print("CONNECT MOVEMENT")
	move.device.mouse.target.hero = hero
	
	for a in [move.act, hero.to.platformer.move.act]:
		a.run.state.hero = hero
		a.velocity.hero = hero
		a.teleport.hero = hero
		a.chains = hero.to.platformer.tools.chains
		a.moving.connect(hero.logic.see.set_direction)
	
	act.levels = hero.to.topdown.levels
	act.actions = hero.to.topdown.actions
	hero.to.platformer.move.act.levels = hero.to.topdown.levels
	hero.to.platformer.move.act.actions = hero.to.platformer.actions
	
	act.moving.connect(hero.view.animation.move)
	act.moving.connect(hero.view.ap.set_direction)

	act.moving.connect(deploy.walls.set_direction)
	act.moving.connect(deploy.ground.set_direction)
	act.moving.connect(deploy.set_direction)
	act.moving.connect(space.set_direction)
	# movement.behavior.move.move.connect(hero.logic.work.input.move.type.velocity.travel)
	# movement.behavior.run.accelerate.connect(hero.logic.stats.accelerate)
	# movement.behavior.run.accelerate.connect(hero.view.animation.moves.set_walk_speed)
