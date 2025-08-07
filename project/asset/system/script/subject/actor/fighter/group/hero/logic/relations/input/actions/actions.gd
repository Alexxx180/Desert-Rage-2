extends Node

@onready var punch: Node = $punch
@onready var kick: Node = $kick
@onready var fire: Node = $fire
@onready var whip: Node = $whip
@onready var combo: Node = $combo

func controls(hero: CharacterBody2D, input: Node) -> void:
	var act: Node = hero.logic.processors.world
	var meta: Dictionary = { "tools": {},
		"combo": {}, "input": input, "act": act }

	for skill in [punch, kick, fire, whip, combo]:
		skill.controls(hero, meta)

	for key in ["tools", "combo"]:
		input.board.set_value(key, meta[key])
	
	input.combo.timeout.connect(input.reset_combo)
