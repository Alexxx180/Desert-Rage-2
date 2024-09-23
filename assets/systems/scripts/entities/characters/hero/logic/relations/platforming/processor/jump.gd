extends Node

@onready var feet: Node = $feet
@onready var overview: Node = $overview

func set_control(hero: CharacterBody2D, processor: Node) -> void:
	overview.set_control(hero, processor.overview)
	processor.move.connect(hero.teleport)
	feet.set_control(processor.feet, hero)
