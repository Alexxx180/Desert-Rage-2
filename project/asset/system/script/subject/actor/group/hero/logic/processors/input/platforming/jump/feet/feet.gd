extends Node

@onready var balance: Node = $balance
@onready var floors: Node = $floors

var deployment: DeploymentRaycast

func same_level(f: int) -> bool:
	print("F: SET = ", floors.F, ", GET = ", f)
	return f != 0 and f == floors.F

func get_ground() -> Vector2:
	var ground: Vector2 = deployment.walls.target
	return floors.tracker.entity.position + ground

func is_same_floor(border: TileMapLayer) -> bool:
	var map_coords: Vector2i = Tile.find(border, get_ground())
	return same_level(Tile.extract(border, map_coords, Tile.FLOOR))

func _direct(overview: Node) -> Vector2i:
	return overview.directions.eyes.direction

func can_land(jump: Node) -> bool:
	return deployment.can_deploy(jump)

func can_deploy(border: TileMapLayer, jump: Node) -> bool:
	return deployment.can_deploy(jump, border)
