extends Node

signal directing(direction: Vector2i)

@onready var movement: Node = $movement
@onready var platforming: Node = $platforming

var x: InputAxis = InputAxis.new("left", "right")
var y: InputAxis = InputAxis.new("forward", "backward")

func _input(_event: InputEvent) -> void:
	directing.emit(Vector2i(x.axis.call(), y.axis.call()))

func set_jump(processor: Node, teleport: Callable) -> void:
	processor.feet.set_movement.connect(set_movement)
	processor.move.connect(teleport)

func set_floors(processor: Node, surface: Node) -> void:
	processor.body_entered.connect(surface.at_new_floor)
	processor.body_exited.connect(surface.at_old_floor)

func set_directing(hero: CharacterBody2D) -> void:
	var processors: Node = hero.logic.processors
	var surface: Node = processors.environment.surface

	set_floors(hero.logic.detectors.platforming.floors, surface)

	var events: Array[Callable] = [hero.set_direction,
		processors.environment.surface.tracking.set_direction,
		platforming.jump.overview.redirect]
	for event in events: directing.connect(event)

func set_surface(hero: CharacterBody2D) -> void:
	var surface: Node = hero.logic.detectors.platforming.platforms.surface
	surface.overleap.body_entered.connect(on_ledge_encounter)

func set_control_entity(hero: CharacterBody2D) -> void:
	set_surface(hero)
	set_directing(hero)
	set_jump(platforming.jump, hero.teleport)
	movement.set_control_entity(hero)

func on_ledge_encounter(_surface: TileMap) -> void:
	Processors.lazy(platforming, platforming.jump.determine)

func set_movement(control: bool) -> void:
	Processors.turn(movement, control)

func _disable_platforming() -> void:
	Processors.disable(platforming.input)
