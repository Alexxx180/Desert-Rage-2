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

func set_control_entity(hero: CharacterBody2D) -> void:
	directing.connect(platforming.jump.overview.redirect)
	set_jump(platforming.jump, hero.teleport)
	movement.set_control_entity(hero)

func on_ledge_encounter(_surface: TileMap) -> void:
	Processors.lazy(platforming, platforming.jump.determine)

func set_movement(control: bool) -> void:
	Processors.turn(movement, control)

func _disable_platforming() -> void:
	Processors.disable(platforming.input)
