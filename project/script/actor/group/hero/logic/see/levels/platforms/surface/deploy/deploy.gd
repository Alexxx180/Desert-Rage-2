extends Node2D

class_name DeploymentRaycast

@onready var walls: Node2D = $walls
@onready var ground: ShapeCast2D = $ground

var _direction: Vector2i = Vector2i.ZERO

func reset_direction() -> void:
	_direction = Vector2i.ZERO

func set_direction(direction: Vector2) -> void:
	var next: Vector2i = Vector2i(roundi(direction.x), roundi(direction.y))
	if next != Vector2i.ZERO:
		_direction = next

func ic(condition: bool, desc: String) -> bool:
	if condition: pass # print("[STOP] Deployment: ", desc)
	return condition

func available_ground() -> bool:
	if ic(_direction == Vector2i.ZERO, "DIRECTION"): return false
	if ic(not ground.is_colliding(), "GROUND"): return false
	return ic(not walls.borders.is_colliding(), "BORDERS")

func can_deploy() -> bool:
	return available_ground() and walls.are_ledges()
