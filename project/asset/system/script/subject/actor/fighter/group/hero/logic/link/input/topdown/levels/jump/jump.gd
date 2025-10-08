extends Node

@onready var feet: Node = $feet

func controls(hero: CharacterBody2D, jump: Node) -> void: # overview controls...
	var levels: Node2D = hero.logic.see.levels
	var ledges: Area2D = levels.platform.ledges
	var type: Node = hero.to.topdown.move.act.teleport

	jump.ledges.space.setup(hero)
	jump.ledges.space.floors = jump.feet.floors
	jump.surface = levels.platform.surface

	ledges.area_entered.connect(jump.ledges.append)
	ledges.area_exited.connect(jump.ledges.remove)

	feet.controls(hero, jump.feet, levels)
