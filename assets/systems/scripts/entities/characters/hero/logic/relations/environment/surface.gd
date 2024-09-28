extends Node

@onready var floors: Node = $floors

func set_control(processor: Node, hero: CharacterBody2D) -> void:
	var jump: Node = hero.logic.processors.input.platforming.jump
	var tracking: Node = processor.tracking

	tracking.set_contacts(hero.geometry.shape.size)
	hero.move.connect(tracking.hero.set_position)
	floors.set_control(processor.floors, jump.overview)
