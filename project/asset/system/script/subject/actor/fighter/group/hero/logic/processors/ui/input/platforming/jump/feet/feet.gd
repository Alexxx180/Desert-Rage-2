extends Node

signal teleport(position: Vector2)
signal dash(position: Vector2)

@onready var balance: Node = $balance
@onready var floors: Node = $floors

# var freeze: bool = false
var _deployment: DeploymentRaycast
var deployment: DeploymentRaycast:
	get: return _deployment
	set(value):
		print("SET DEPLOYMENT")
		_deployment = value
		_deployment.walls.same_floor = same_level

func get_ground() -> Vector2:
	var ground: Vector2 = deployment.walls.target
	return floors.hero.position + ground

func same_level(border: TileMapLayer, pos: Vector2 = get_ground(), height: int = 0) -> bool:
	var f: int = Tile.extract_at_pos(border, pos, Tile.FLOOR) + height
	print("FLOOR: ", f, " OF: ", floors.F)
	return f == floors.F

func deploy(border: TileMapLayer = null) -> void:
	if deployment.can_deploy(border):
		jump(deployment.walls.target, true, dash)

func jump(next: Vector2, to_floor: bool = false, move = teleport) -> void:
	move.emit(next)
	balance.stable = to_floor
