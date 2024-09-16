extends Node2D

signal floors(F: int, position: Vector2)

const DISTANCE: int = 128
const CENTER: Vector2i = Vector2i.ZERO

var tracking: Node

@onready var walls: ShapeCast2D = $walls
@onready var surface: RayCast2D = $surface
@onready var half: Vector2 = walls.shape.size / 2

func set_control_entity(hero: CharacterBody2D) -> void:
	tracking = hero.detectors.platform.floors.ground.tilemap.tracking

func _raycast(source: Node2D, target: Vector2) -> bool:
	source.position = target
	return source.is_colliding()

func _no_walls(direction: Vector2) -> bool:
	return not _raycast(walls, surface.target_position + (half * direction))

func _intersect(direction: Vector2) -> bool:
	return _raycast(surface, direction * DISTANCE)

func search(next: Vector2i) -> void:
	if next != CENTER and _intersect(next) and _no_walls(next):
		var center: Vector2 = tracking.get_contact(CENTER) + walls.position + half
		var collider: Object = surface.get_collider()
		floors.emit(Tiler.get_tile(collider, center), walls.position)
