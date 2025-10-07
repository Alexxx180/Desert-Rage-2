extends Node

@onready var range: Node = $range
@onready var music: Node = $music

func controls(hero: CharacterBody2D, fight: Node) -> void:
	music.controls(hero)
	range.controls(hero, fight)
	fight.movement.hero = hero
	var group: Node2D = hero.get_parent()
	fight.deploy = group.deploy
