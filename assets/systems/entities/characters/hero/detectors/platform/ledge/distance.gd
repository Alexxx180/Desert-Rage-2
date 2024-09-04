extends Node2D

var F: int = 0

const DISTANCE: int = 128
const CENTER: Vector2i = Vector2i.ZERO

var tracking: Node

var direction: Vector2 = Vector2.ZERO
var half: Vector2
var center: Vector2:
	get: return tracking.get_contact(CENTER) + walls.position + half

@onready var walls: ShapeCast2D = $walls
@onready var surface: RayCast2D = $surface

func _ready(): half = walls.shape.size / 2

func set_control_entity(hero: CharacterBody2D) -> void:
	tracking = hero.detectors.platform.floors.ground.tilemap.tracking

func route(hero: CharacterBody2D) -> Vector2:
	return hero.position + surface.target_position

func _set_floor() -> bool:
	F = Tiler.get_tile(surface.get_collider(), center)
	return true

func _no_walls():
	walls.position = surface.target_position + (half * direction)
	return not walls.is_colliding()

func _intersect() -> bool:
	surface.target_position = direction * DISTANCE
	return surface.is_colliding()

func search(next: Vector2i) -> bool:
	direction = next
	return next != CENTER and _intersect() and _no_walls() and _set_floor()
