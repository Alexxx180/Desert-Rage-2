extends Node2D

class_name DeploymentRaycast

signal free_space(deployment: DeploymentRaycast)

const DISTANCE: int = 128

@onready var walls: ShapeCast2D = $walls
@onready var surface: RayCast2D = $surface
@onready var _half: Vector2 = walls.shape.size / 2

func contact() -> Vector2:
	return walls.position + _half

func _no_walls(direction: Vector2) -> bool:
	walls.position = surface.target_position
	walls.position += _half * direction
	return not walls.is_colliding()

func _intersect(direction: Vector2) -> bool:
	surface.target_position = direction * DISTANCE
	return surface.is_colliding()

func can_deploy(direction: Vector2i) -> bool:
	return _intersect(direction) and _no_walls(direction)

func search(next: Vector2i) -> void:
	free_space.emit(next, self)
