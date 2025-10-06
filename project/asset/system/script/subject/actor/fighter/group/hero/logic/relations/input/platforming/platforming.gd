extends Node

@onready var jump: Node = $jump
@onready var input: Node = $input
@onready var chains: Node = $chains
@onready var pillar: Node = $pillar
@onready var spring: Node = $spring

func controls(hero: CharacterBody2D, levels: Node) -> void:
	var platforms: Node2D = hero.logic.see.levels.platforms

	hero.logic.see.levels.stand.hero = hero
	jump.controls(hero, levels.jump)
	input.controls(hero, levels, platforms.surface.overleap)
	pillar.controls(hero, levels.pillar)
	
	var tools: Node = hero.logic.work.input.platformer.tools
	
	chains.controls(hero, tools.chains)
	spring.controls(hero, tools.jump)
