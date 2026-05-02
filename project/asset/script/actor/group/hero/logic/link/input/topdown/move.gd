extends Node

var _hero: VeloHero
var space: Node:
	get: return _hero.to.topdown.levels.jump.ledges.space
var deploy: DeploymentRaycast:
	get: return _hero.to.platform.surface.deploy

func controls(hero: VeloHero, move: Node) -> void:
	_hero = hero
	print("CONNECT MOVEMENT")
	# move.device.mouse.target.hero = hero # TODO FIXME MOUSE MOVEMENT
	# TODO FIXME connect platformer skills
	# connect_platformer([move.act, hero.to.platformer.move.act], hero)
	#move.act.levels = hero.to.topdown.levels
	#move.act.actions = hero.to.topdown.actions
	move.act.moving.connect(_moving)

	# movement.behavior.move.move.connect(hero.logic.work.input.move.type.velocity.travel)
	# movement.behavior.run.accelerate.connect(hero.logic.stats.accelerate)
	# movement.behavior.run.accelerate.connect(hero.view.animation.moves.set_walk_speed)

func connect_platformer(moves: Array, hero: CharacterBody2D) -> void:
	hero.to.platformer.move.act.levels = hero.to.topdown.levels
	hero.to.platformer.move.act.actions = hero.to.platformer.actions
	for a in moves:
		a.run.state.hero = hero
		a.velocity.hero = hero
		a.teleport.platform.hero = hero
		a.chains = hero.to.platformer.tools.chains
		a.moving.connect(hero.logic.see.set_direction)

func _moving(velocity: Vector2) -> void:
	_hero.view.animation.move(velocity)
	deploy.walls.set_direction(velocity)
	deploy.ground.set_direction(velocity)
	deploy.set_direction(velocity)
	space.set_direction(velocity)
	# act.moving.connect(hero.view.ap.set_direction)
