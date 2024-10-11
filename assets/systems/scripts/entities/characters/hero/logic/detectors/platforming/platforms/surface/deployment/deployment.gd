extends Node2D

class_name DeploymentRaycast

@onready var walls: ShapeCast2D = $walls
@onready var ground: ShapeCast2D = $ground

func can_deploy(direction: Vector2i) -> bool:
	print("DIRECTION")
	if direction == Vector2i.ZERO: return false

	print("GROUND")
	if not ground.is_colliding(): return false

	print("WALLS")
	return not walls.is_colliding()
