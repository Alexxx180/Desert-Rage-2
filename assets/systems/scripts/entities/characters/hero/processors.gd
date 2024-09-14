extends Node

@onready var input: Node = $input
@onready var platforming: Node = $platforming
@onready var movement: Node = $movement

func set_control_entity(hero: CharacterBody2D) -> void:
	input.directing.connect(platforming.jump.overview.redirect)
	platforming.jump.feet.set_movement.connect(set_movement)
	platforming.jump.move.connect(hero.repositioning)
	movement.move.connect(hero.sliding_flow)
	movement.accelerate.connect(hero.accelerate)

func on_ledge_encounter(_surface: TileMap) -> void:
	platforming.process_mode = Processors.will
	platforming.jump.perform_jump(input.previous)
	Processors.turn(platforming, platforming.jump.feet.unstable)

func set_movement(control: bool) -> void:
	Processors.turn(movement, control)

func _disable_platforming() -> void:
	platforming.input.process_mode = Processors.wont
