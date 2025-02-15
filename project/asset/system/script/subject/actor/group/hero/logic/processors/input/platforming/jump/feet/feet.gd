extends Node

@onready var balance: Node = $balance
@onready var height: Node = $height

var deployment: DeploymentRaycast
var surface: SurfaceTracker

func same_level(overview: Node, f: int) -> bool:
	#print("Overview: ", overview.height.F, " - F:", f)
	return f != 0 and f == overview.height.F

func is_same_floor(floors: TileMapLayer, overview: Node) -> bool:
	var ground: Vector2 = deployment.walls.target
	var tile: Vector2 = surface.entity.position + ground
	var map_coords: Vector2i = Tile.find(floors, tile)

	var f: int = Tile.extract(floors, map_coords, Tile.Atlas.FLOOR)
	#print("Detecting floor: ", f)

	height.set_floor(f)
	return same_level(overview, height.F)

func _direct(overview: Node) -> Vector2i:
	return overview.directions.eyes.direction

func can_land(jump: Node) -> bool:
	return deployment.can_deploy(jump)

func can_deploy(floors: TileMapLayer, jump: Node) -> bool:
	return deployment.can_deploy(jump, floors)
