extends Node

@onready var jump: Node = $jump
@onready var input: Node = $input

func controls(hero: CharacterBody2D, platforming: Node) -> void:
	var platforms: Node2D = hero.logic.detectors.platforming.platforms

	jump.controls(hero, platforming.jump)
	input.controls(hero, platforming.input, platforms.surface.overleap)
