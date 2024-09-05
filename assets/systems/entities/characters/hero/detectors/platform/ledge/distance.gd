extends Node2D

var F: int = 0

signal floors(F: int, position: Vector2)

const DISTANCE: int = 128
const CENTER: Vector2i = Vector2i.ZERO

var tracking: Node

var direction: Vector2 = Vector2.ZERO
var half: Vector2

@onready var walls: ShapeCast2D = $walls
@onready var surface: RayCast2D = $surface

func _ready(): half = walls.shape.size / 2

func _get_center(basis: Vector2) -> Vector2:
	return basis + walls.position + half

func set_control_entity(hero: CharacterBody2D) -> void:
	tracking = hero.detectors.platform.floors.ground.tilemap.tracking

func route(hero: CharacterBody2D) -> Vector2:
	return hero.position + surface.target_position

func _no_walls():
	walls.position = surface.target_position + (half * direction)
	return not walls.is_colliding()

func _intersect() -> bool:
	surface.target_position = direction * DISTANCE
	return surface.is_colliding()

func search(next: Vector2i) -> void:
	direction = next
	if next != CENTER and _intersect() and _no_walls():
		var center: Vector2 = _get_center(tracking.get_contact(CENTER))
		var collider: Object = surface.get_collider()
		floors.emit(Tiler.get_tile(collider, center), walls.position)
