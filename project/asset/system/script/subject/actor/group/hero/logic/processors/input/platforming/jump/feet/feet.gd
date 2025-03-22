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

func same_floor(f: int) -> bool:
	return f != 0 and f == floors.F

func get_ground() -> Vector2:
	var ground: Vector2 = deployment.walls.target
	return floors.tracker.entity.position + ground

func same_level(border: TileMapLayer) -> bool:
	var ground: Vector2 = get_ground()
	print("Ground target: ", ground, " AND BORDER = NULL: ", border == null)
	var map_coords: Vector2i = Tile.find(border, ground)
	return same_floor(Tile.extract(border, map_coords, Tile.FLOOR))

func deploy(border: TileMapLayer = null) -> void:
	if deployment.can_deploy(border):
		jump(deployment.walls.target, true, dash)

func set_midair(control: Node, is_in_midair: bool = balance.unstable) -> void:
	control.available = is_in_midair
	#if not floors.freeze:
	floors.freeze = is_in_midair

func jump(next: Vector2, to_floor: bool = false, move = teleport) -> void:
	move.emit(next)
	balance.stable = to_floor
