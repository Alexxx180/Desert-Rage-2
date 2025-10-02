extends Node

signal teleport(position: Vector2)
signal dash(position: Vector2)
signal set_movement(is_floor: bool)

@onready var floors: Node = $floors

var _stable: bool = true
var stable: bool:
	get: return _stable
var unstable: bool:
	get: return not _stable

func set_stable(is_floor: bool) -> void:
	if is_floor != _stable:
		set_movement.emit(is_floor)
		_stable = is_floor

var _deployment: DeploymentRaycast
var deployment: DeploymentRaycast:
	get: return _deployment
	set(value):
		print("SET DEPLOYMENT")
		_deployment = value
		_deployment.walls.floors = floors

func get_ground() -> Vector2:
	var ground: Vector2 = deployment.walls.target
	return floors.hero.position + ground

func same_level(pos: Vector2 = get_ground(), height: int = 0) -> bool:
	return floors.same(pos, height)

func deploy() -> void:
	if deployment.can_deploy():
		jump(deployment.walls.target_ground, true, dash)

func jump(next: Vector2, to_floor: bool = false, move = teleport) -> void:
	move.emit(next)
	set_stable(to_floor)
