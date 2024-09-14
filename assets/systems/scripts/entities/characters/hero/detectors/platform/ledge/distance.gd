extends Node2D

signal floors(F: int, position: Vector2)

const DISTANCE: int = 128
const CENTER: Vector2i = Vector2i.ZERO

var tracking: Node
var direction: Vector2 = Vector2.ZERO
var half: Vector2

var F: int = 0

@onready var walls: ShapeCast2D = $walls
@onready var surface: RayCast2D = $surface

func set_control_entity(hero: CharacterBody2D) -> void:
	tracking = hero.detectors.platform.floors.ground.tilemap.tracking

func _ready(): half = walls.shape.size / 2

func _get_center(basis: Vector2) -> Vector2:
	return basis + walls.position + half

func route(hero: CharacterBody2D) -> Vector2:
	return hero.position + surface.target_position

func _raycast(source: Node2D, target: Vector2) -> bool:
	source.position = target
	return source.is_colliding()

func _no_walls():
	return not _raycast(walls, surface.target_position + (half * direction))

func _intersect() -> bool:
	return _raycast(surface, direction * DISTANCE)

func search(next: Vector2i) -> void:
	direction = next
	if next != CENTER and _intersect() and _no_walls():
		var center: Vector2 = _get_center(tracking.get_contact(CENTER))
		var collider: Object = surface.get_collider()
		floors.emit(Tiler.get_tile(collider, center), walls.position)
