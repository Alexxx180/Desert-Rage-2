extends Node

@onready var jump: Node = $jump
@onready var input: Node = $input
@onready var chains: Node = $chains

func controls(hero: CharacterBody2D, platforming: Node) -> void:
	var platforms: Node2D = hero.logic.detectors.platforming.platforms

	hero.logic.detectors.platforming.stand.hero = hero
	jump.controls(hero, platforming.jump)
	input.controls(hero, platforming, platforms.surface.overleap)
	chains.controls(hero, platforming.chains)
