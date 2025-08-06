extends Node

@onready var punch: Node = $punch
@onready var kick: Node = $kick
@onready var fire: Node = $fire
@onready var whip: Node = $whip

func controls(hero: CharacterBody2D, input: Node) -> void:
	var act: Node = hero.logic.processors.world
	input.board.set_value("combo", {})
	var meta: Dictionary = {
		"tools": {}, "board": input.board, "act": act }
	for skill in [punch, kick, fire, whip]:
		skill.controls(hero, meta)
	input.board.set_value("tools", meta.tools)
