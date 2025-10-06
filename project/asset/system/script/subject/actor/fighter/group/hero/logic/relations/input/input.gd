extends Node

@onready var platforming: Node = $platforming
@onready var movement: Node = $movement
@onready var actions: Node = $actions

func controls(hero: CharacterBody2D, input: Node) -> void:
	# hero.action_move.connect(hero.view.animation.action_move)

	actions.controls(hero, input)
	movement.controls(hero, input.topdown.move)
	platforming.controls(hero, input.topdown.levels)
	
	"""
	input.actions.check.action.connect(func():
		hero.view.animation.moves.set_fight_start("active")
		hero.view.animation.moves.set_fighting("hands"))

	input.actions.check.skill_two.connect(
		hero.logic.processors.ui.input.platforming.pillar.dash_on_whip)

	input.actions.check.kick.connect(func():
		hero.view.animation.moves.set_fight_start("active")
		hero.view.animation.moves.set_fighting("legs"))
	"""

	# hero.logic.processors.environment
	# input.directing.connect(environment.surface.tracking.map.set_direction)
