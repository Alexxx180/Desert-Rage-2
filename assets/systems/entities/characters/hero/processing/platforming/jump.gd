extends Node

var hero: CharacterBody2D
var detectors: Node2D

@onready var overview: Node = $overview
@onready var feet: Node = $feet

func set_control_entity(entity: CharacterBody2D) -> void:
	hero = entity
	detectors = hero.detectors.platform.ledge
	feet.set_control_entity(hero.processing)
	overview.set_control_entity(hero)
	var floors: Area2D = detectors.distance.deployment.floors
	floors.body_entered.connect(jump_to_floor)

func _jump(is_floor: bool, next: Vector2):
	feet.stable = is_floor
	hero.position = next 

func perform_jump(direction: Vector2i):
	overview.direction = direction
	if detectors.ledges.around(overview):
		_jump(false, detectors.ledges.ledge.pos)
	elif feet.unstable:
		detectors.distance.floor_search(direction)

func jump_to_floor(surface: StaticBody2D) -> void:
	if not detectors.distance.reachable(): return
	if overview.surface.F != surface.F: return
	_jump(true, detectors.distance.route(hero))
