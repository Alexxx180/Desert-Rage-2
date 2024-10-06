extends Node

@onready var feet: Node = $feet
@onready var overview: Node = $overview

func set_control(hero: CharacterBody2D, jump: Node) -> void:
	overview.set_control(hero, jump.overview)
	jump.dash.connect(hero.dash)
	jump.teleport.connect(hero.teleport)
	feet.set_control(jump.feet, hero)
