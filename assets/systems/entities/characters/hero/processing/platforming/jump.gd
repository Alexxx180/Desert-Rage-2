extends Node

var hero: CharacterBody2D
var detectors: Node2D
var deployment: Node2D

@onready var overview: Node = $overview
@onready var feet: Node = $feet

func set_control_entity(entity: CharacterBody2D) -> void:
	hero = entity
	detectors = hero.detectors.platform.ledge
	feet.set_control_entity(hero.processing)
	overview.set_control_entity(hero)
	deployment = detectors.distance.deployment

func _jump(is_floor: bool, next: Vector2):
	feet.stable = is_floor
	hero.position = next

func perform_jump(direction: Vector2i):
	overview.direction = direction
	if detectors.ledges.around(overview):
		_jump(false, detectors.ledges.ledge.pos)
	else:
		detectors.distance.floor_search(direction)
		if not detectors.distance.unreachable():
			print("can reach")
			jump_to_floor()
		else:
			print("can't reach")
			deployment.disable()

func jump_to_floor() -> void: # StaticBody2D
	print("JUMP!!")
	
	var can_jump: bool = deployment.can_jump
	var F: int = detectors.distance.F
	print("CAN: ", can_jump)
	print("FLOOR IS: ", F)
	print("PREVIOUS: ", overview.surface.F)
	#deployment.call_deferred("disable")
	deployment.disable()
	if F == 0 or overview.surface.F != F: return
	detectors.distance.F = 0

	var is_box = feet.unstable
	_jump(true, detectors.distance.route(hero))
	if is_box: hero.processing.platforming.process_mode = Node.PROCESS_MODE_DISABLED
