extends Node2D

class_name DeploymentRaycast

signal on_floors_encounter(deployment: DeploymentRaycast)

const DISTANCE: int = 128

@onready var walls: ShapeCast2D = $walls
@onready var surface: RayCast2D = $surface
@onready var half: Vector2 = walls.shape.size / 2

func _raycast(source: Node2D, target: Vector2) -> bool:
	source.position = target
	return source.is_colliding()

func _no_walls(direction: Vector2) -> bool:
	return not _raycast(walls, surface.target_position + (half * direction))

func _intersect(direction: Vector2) -> bool:
	return _raycast(surface, direction * DISTANCE)

func search(next: Vector2i) -> void:
	if next != Vector2i.ZERO and _intersect(next) and _no_walls(next):
		on_floors_encounter.emit(self)
