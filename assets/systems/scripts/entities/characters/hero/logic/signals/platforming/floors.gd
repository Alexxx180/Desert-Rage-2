extends Node

static func area_connect(processor: Area2D, enter: Callable, exit: Callable) -> void:
	processor.body_entered.connect(enter)
	processor.body_exited.connect(exit)

static func set_control(surface: Node, processors: Node) -> void:
	var storage: Node = processors.input.platforming.jump.ledges

	processor.body_entered.connect(surface.at_new_floor)
	processor.body_exited.connect(surface.at_old_floor)

	area_connect(platforming.floors, 
	area_connect(platforming.platforms.ledges, storage.append, storage.remove)
