extends RefCounted

class_name HeroSignalsArea

static func area_connect(processor: Area2D, enter: Callable, exit: Callable) -> void:
	processor.body_entered.connect(enter)
	processor.body_exited.connect(exit)

static func apply(platforming: Node2D, processors: Node) -> void:
	var surface: Node = processors.environment.surface
	var storage: Node = processors.input.platforming.jump.ledges

	area_connect(platforming.floors, surface.at_new_floor, surface.at_old_floor)
	area_connect(platforming.platforms.ledges, storage.append, storage.remove)
