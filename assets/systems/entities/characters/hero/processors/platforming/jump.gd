extends Node

signal on_jump(position: Vector2)
signal disable()

var hero: CharacterBody2D
var detectors: Node2D

@onready var overview: Node = $overview
@onready var feet: Node = $feet
@onready var ledges: Node = $ledges

func set_control_entity(entity: CharacterBody2D) -> void:
	hero = entity
	detectors = hero.detectors.platform.ledge
	feet.set_control_entity(hero.processing)
	overview.set_control_entity(hero)

func _jump(is_floor: bool, next: Vector2):
	feet.stable = is_floor
	on_jump.emit(next)

func determine(direction: Vector2i):
	overview.direction = direction
	if ledges.around(overview):
		_jump(false, ledges.current.pos)
	elif detectors.floors.search(direction):
		_jump_to_floor()

func _jump_to_floor() -> void:
	var F: int = detectors.distance.F
	detectors.distance.deployment.disable()

	print("Jump from ", overview.surface.F, " floor to ", F)

	if F == 0 or overview.surface.F != F: return
	detectors.distance.F = 0

	var is_box = feet.unstable
	_jump(true, detectors.distance.route(hero))
	if is_box: disable.emit()
