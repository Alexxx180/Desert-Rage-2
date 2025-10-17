extends Node

func controls(hero: CharacterBody2D, chains: Node) -> void:
	var input: Node = hero.logic.work.input
	var see: Node2D = hero.logic.see.levels.tools.chains

#	see.pillar.body_entered.connect(chains.climbing_start)
#	see.pillar.body_exited.connect(chains.climbing_stop)

	
#	see.unit.body_entered.connect(chains.move_above)
#	see.unit.body_exited.connect(chains.move_under)

# TODOT
	chains.see = see
	chains.catch.input = input
	chains.catch.view = hero.view
	# chains.catch.view = hero.view
	chains.catch.control = input.platformer.tools.jump.spring.control
	chains.catch.chained.connect(input.topdown.levels.pillar.set_ledge)
#	chains.catch.velocity = input.topdown.move.act.velocity
