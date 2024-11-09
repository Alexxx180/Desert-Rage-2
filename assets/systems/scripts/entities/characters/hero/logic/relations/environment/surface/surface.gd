extends Node

@onready var floors: Node = $floors

func set_control(surface: Node, hero: CharacterBody2D) -> void:
	var jump: Node = hero.logic.processors.input.platforming.jump
	var tracking: Node = surface.tracking

	tracking.set_contacts(hero.geometry.shape.size)
	tracking.entity = hero
	floors.set_control(surface.floors, jump.overview)
