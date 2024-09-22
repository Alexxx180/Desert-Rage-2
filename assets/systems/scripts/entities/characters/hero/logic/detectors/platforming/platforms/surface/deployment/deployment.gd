extends Node2D

class_name DeploymentRaycast

signal prepare(deployment: DeploymentRaycast)
signal deploy(F: int, position: Vector2)

@onready var walls: ShapeCast2D = $walls
@onready var surface: RayCast2D = $surface

func can_deploy(direction: Vector2i) -> bool:
	if direction == Vector2i.ZERO: return false
	if not surface.detected(direction): return false
	return walls.freed(surface, direction)

func search(direction: Vector2i) -> void:
	if can_deploy(direction):
		prepare.emit(self)
	else:
		deploy.emit(0, direction)
