extends Node2D

class_name DeploymentRaycast

@onready var walls: Node2D = $walls
@onready var ground: ShapeCast2D = $ground

func available_ground(direction: Vector2i) -> bool:
	#print("DIRECTION")
	if direction == Vector2i.ZERO: return false
	#print("GROUND")
	return ground.is_colliding() # not - return false

func can_deploy(direction: Vector2i) -> bool:
	#print("WALLS")
	return (available_ground(direction) and
		not walls.center.is_colliding())
