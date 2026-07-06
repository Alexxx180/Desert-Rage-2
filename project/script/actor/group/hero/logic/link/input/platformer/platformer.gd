extends Node

func controls(hero: CharacterBody2D, tools: Node) -> void:
	controls_chains(hero, tools.chains)
	controls_spring(hero, tools.jump)

func controls_chains(hero: CharacterBody2D, chains: Node) -> void:
	var input: Node = hero.logic.work.input
	var see: Node2D = hero.logic.see.levels.tools.chains

#	see.pillar.body_entered.connect(chains.climbing_start)
#	see.pillar.body_exited.connect(chains.climbing_stop)

	
#	see.unit.body_entered.connect(chains.move_above)
#	see.unit.body_exited.connect(chains.move_under)
	chains.see = see
# TODOT
	chains.catch.input = input
	chains.catch.view = hero.view
	# chains.catch.view = hero.view
	chains.catch.control = input.platformer.tools.jump.spring.control
	chains.catch.chained.connect(input.topdown.levels.pillar.set_ledge)
#	chains.catch.velocity = input.topdown.move.act.velocity

func controls_spring(hero: CharacterBody2D, jump: Node) -> void:
	var see: Node2D = hero.to.tools.spring
	var control: Node = jump.spring.control # TODOT SPRING

	control.platform = see.platform
	control.layers = hero.to.layers
	control.input = hero.logic.work.input

	control.ground = jump.spring.ground
	control.slide = jump.slide

	jump.slide.slide = see.slide
	jump.slide.walls = see.walls
	jump.slide.hero = hero
	jump.spring.spring = see.spring
	if hero.group.lay != null:
		jump.spring.ground.execute = hero.group.lay.execute
