extends RefCounted

class_name HeroSignalsJump

static func apply(hero: CharacterBody2D) -> void:
	var processors: Node = hero.logic.processors
	var input: Node = processors.input
	var jump: Node = input.platforming.jump

	jump.feet.set_movement.connect(input.set_movement)
	jump.move.connect(hero.teleport)
