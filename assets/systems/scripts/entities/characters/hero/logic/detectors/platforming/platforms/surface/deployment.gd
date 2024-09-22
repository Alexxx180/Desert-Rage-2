extends Node2D

class_name DeploymentRaycast

signal prepare(deployment: DeploymentRaycast)
signal deploy(F: int, position: Vector2)

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

func can_deploy(dir: Vector2i) -> bool:
	return dir != Vector2i.ZERO and _intersect(dir) and _no_walls(dir)

func search(direction: Vector2i) -> void:
	if can_deploy(direction):
		prepare.emit(self)
	else:
		deploy.emit(0, direction)
