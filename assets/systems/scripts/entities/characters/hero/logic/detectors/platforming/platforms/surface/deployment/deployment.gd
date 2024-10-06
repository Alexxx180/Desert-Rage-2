extends Node2D

class_name DeploymentRaycast

@onready var walls: ShapeCast2D = $walls
@onready var ground: ShapeCast2D = $ground
@onready var surface: RayCast2D = $surface

func can_deploy(direction: Vector2i) -> bool:
	print("DIRECTION")
	if direction == Vector2i.ZERO: return false

	print("SURFACE")
	if not surface.detected(direction): return false

	print("GROUND")
	if not ground.present(surface): return false

	print("WALLS")
	return not walls.present(surface)
