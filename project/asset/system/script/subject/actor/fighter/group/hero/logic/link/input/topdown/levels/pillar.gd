extends Node

func controls(hero: CharacterBody2D, pillar: Node) -> void:
	var levels: Node2D = hero.logic.see.levels
	var env: Node = pillar.env
	env.view = hero.view
	env.whip = levels.tools.chains.whip
	env.layers = hero.to.layers
	env.chains = hero.to.platformer.tools.chains
	env.floors = hero.to.topdown.levels.jump.feet.floors
	env.teleport = hero.to.topdown.move.act.teleport
	env.levels = levels

	pillar.ledges.env = env
	pillar.ledges.ledge.node = levels.tools.pillar
