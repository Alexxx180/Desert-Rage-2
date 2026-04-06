extends Node

@onready var input: Node = $input
@onready var world: Node = $world
# @onready var stats: Node = $stats

func controls(hero: VeloHero) -> void:
	var work: Node = hero.logic.work
	hero.hero.to.moves.hero = hero.hero
	input.controls(hero, work.input)
	world.controls(hero, work.world)
	# stats.controls(hero, work.stats)
