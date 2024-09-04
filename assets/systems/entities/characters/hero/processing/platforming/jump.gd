extends Node

signal on_jump(position: Vector2)

var hero: CharacterBody2D
var detectors: Node2D

@onready var overview: Node = $overview
@onready var feet: Node = $feet

func set_control_entity(entity: CharacterBody2D) -> void:
	hero = entity
	detectors = hero.detectors.platform.ledge
	feet.set_control_entity(hero.processing)
	overview.set_control_entity(hero)

func _jump(is_floor: bool, next: Vector2):
	feet.stable = is_floor
	on_jump.emit(next)
	hero.position = next

func perform_jump(direction: Vector2i):
	overview.direction = direction
	if detectors.ledges.around(overview):
		_jump(false, detectors.ledges.ledge.pos)
	elif detectors.distance.floor_search(direction):
		jump_to_floor()
	else:
		detectors.distance.deployment.disable()

func jump_to_floor() -> void:
	var F: int = detectors.distance.F
	detectors.distance.deployment.disable()

	print("Jump from ", overview.surface.F, " floor to ", F)

	if F == 0 or overview.surface.F != F: return
	detectors.distance.F = 0

	var is_box = feet.unstable
	_jump(true, detectors.distance.route(hero))
	if is_box: hero.processing.platforming.process_mode = Node.PROCESS_MODE_DISABLED
