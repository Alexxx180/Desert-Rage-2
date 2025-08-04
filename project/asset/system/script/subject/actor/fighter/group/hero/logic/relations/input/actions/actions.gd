extends Node

@onready var punch: Node = $punch
@onready var kick: Node = $kick

func controls(hero: CharacterBody2D, input: Node) -> void:
	var act: Node = hero.logic.processors.world
	punch.controls(hero, input.board, act)
	kick.controls(hero, input.board, act)
