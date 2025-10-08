extends Node

@onready var jump: Node = $jump
@onready var pillar: Node = $pillar

func controls(hero: CharacterBody2D, levels: Node) -> void:
	hero.to.platform.cargo.hero = hero
	jump.controls(hero, levels.jump)
	pillar.controls(hero, levels.pillar)
