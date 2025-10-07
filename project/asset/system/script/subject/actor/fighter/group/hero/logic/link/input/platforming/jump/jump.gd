extends Node

@onready var feet: Node = $feet

func controls(hero: CharacterBody2D, jump: Node) -> void:
	# overview controls...
	var levels: Node2D = hero.logic.see.levels
	var ledges: Area2D = levels.platforms.ledges
	var type: Node = hero.logic.work.input.topdown.move.act.teleport

	jump.feet.dash.connect(type.dash)
	jump.feet.teleport.connect(type.teleport)

	jump.ledges.space.setup(hero)
	jump.ledges.space.floors = jump.feet.floors
	jump.surface = levels.platforms.surface

	ledges.area_entered.connect(jump.ledges.append)
	ledges.area_exited.connect(jump.ledges.remove)

	feet.controls(hero, jump.feet, levels)
