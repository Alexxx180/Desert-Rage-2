extends Node

@onready var platformer: Node = $platformer
@onready var levels: Node = $levels
@onready var move: Node = $move
@onready var actions: Node = $actions

func controls(hero: VeloHero, input: Node) -> void:
	var topdown: Node = input.topdown
	# actions.controls(hero, topdown)
	move.controls(hero, topdown.move)
	# TODO FIXME platforming connect
	# levels.controls(hero, topdown.levels.jump)
	# levels.controls_pillar(hero, topdown.levels.pillar)
	# TODO FIXME platformer connect
	# platformer.controls(hero, input.platformer.tools)
