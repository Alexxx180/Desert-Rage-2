extends RefCounted

class_name HeroSignals

func _init(input: Node, hero: CharacterBody2D) -> void:
	var surface: Node = hero.logic.processors.environment.surface
	var jump: Node = input.platforming.jump

	var detectors: Node2D = hero.logic.detectors
	var platforming: Node2D = detectors.platforming
	var platforms: Node2D = platforming.platforms
	var overleap: Area2D = platforms.surface.overleap

	overleap.body_entered.connect(input.on_ledge_encounter)

	var storage: Node = jump.ledges

	area_connect(platforming.floors, surface.at_new_floor, surface.at_old_floor)
	area_connect(platforms.ledges, storage.append, storage.remove)

	set_directing(input, [hero.set_direction,
		surface.tracking.set_direction, jump.overview.redirect])

	jump.feet.set_movement.connect(input.set_movement)
	jump.move.connect(hero.teleport)

func area_connect(processor: Area2D, enter: Callable, exit: Callable) -> void:
	processor.body_entered.connect(enter)
	processor.body_exited.connect(exit)

func set_directing(input: Node, events: Array[Callable]) -> void:
	for event in events: input.directing.connect(event)
