extends Node2D

class_name DeploymentRaycast

signal free_space(deployment: DeploymentRaycast)

const DISTANCE: int = 128

@onready var walls: ShapeCast2D = $walls
@onready var surface: RayCast2D = $surface
@onready var half: Vector2 = walls.shape.size / 2

func _no_walls(direction: Vector2) -> bool:
	walls.position = surface.target_position + half * direction
	return not walls.is_colliding()

func _intersect(direction: Vector2) -> bool:
	surface.target_position = direction * DISTANCE
	return surface.is_colliding()

func search(next: Vector2i) -> void:
	if next != Vector2i.ZERO and _intersect(next) and _no_walls(next):
		free_space.emit(self)
