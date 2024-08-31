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
	deployment.floors.body_entered.connect(jump_to_floor)

func _jump(is_floor: bool, next: Vector2):
	feet.stable = is_floor
	hero.position = next

func perform_jump(direction: Vector2i):
	overview.direction = direction
	if detectors.ledges.around(overview):
		_jump(false, detectors.ledges.ledge.pos)
	else:
		detectors.distance.floor_search(direction)

func jump_to_floor(surface: TileMap) -> void: # StaticBody2D
	print("JUMP!!")
	if detectors.distance.unreachable(): return
	# var F: int = hero.detectors.platform.floors.ground.tilemap.find_tile(surface)
	var F: int = Tiler.get_tile(surface, deployment.center)
	print("FLOOR IS: ", F)
	print("PREVIOUS: ", overview.surface.F)
	if overview.surface.F != F: return
	_jump(true, detectors.distance.route(hero))
