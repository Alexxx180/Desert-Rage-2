extends Node

func controls(hero: CharacterBody2D, floors: Node) -> void:
	floors.border = hero.group.lay.border
	floors.hero = hero
