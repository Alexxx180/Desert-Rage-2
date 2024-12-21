extends Node2D

class_name DeploymentRaycast

@onready var walls: Node2D = $walls
@onready var ground: ShapeCast2D = $ground

func available_ground(direction: Vector2i) -> bool:
	#print("DIRECTION")
	if direction == Vector2i.ZERO: return false
	#print("GROUND")
	if not ground.is_colliding(): return false
	#print("BORDERS")
	return not walls.borders.is_colliding()

func can_deploy(feet: Node, overview: Node, floors: TileMapLayer = null) -> bool:
	var eyes: Node = overview.directions.eyes

	return (available_ground(eyes.direction) and
		walls.are_ledges(feet, overview, floors))
