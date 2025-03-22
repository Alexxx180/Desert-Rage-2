extends Node2D

class_name DeploymentRaycast

@onready var walls: Node2D = $walls
@onready var ground: ShapeCast2D = $ground

var _direction: Vector2i = Vector2i.ZERO

func set_direction(direction: Vector2i) -> void:
	_direction = direction

func ic(condition: bool, desc: String) -> bool:
	if not condition: print("[STOP] Deployment: ", desc)
	return condition

func available_ground() -> bool:
	if ic(_direction == Vector2i.ZERO, "DIRECTION"): return false
	if ic(not ground.is_colliding(), "GROUND"): return false
	return ic(not walls.borders.is_colliding(), "BORDERS")

func can_deploy(floors: TileMapLayer = null) -> bool:
	return available_ground() and walls.are_ledges(floors)
