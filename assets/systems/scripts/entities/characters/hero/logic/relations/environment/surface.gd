extends Node

@onready var floors: Node = $floors

func set_control(processor: Node, hero: CharacterBody2D) -> void:
	var jump: Node = hero.logic.processors.input.platforming.jump

	processor.on_floors.connect(jump.placement)
	processor.set_contacts(hero.geometry.shape.size)
	hero.move.connect(processor.hero.set_position)
	floors.set_control(processor.floors, jump.overview)
