extends Node

@onready var balance: Node = $balance
@onready var height: Node = $height

var deployment: DeploymentRaycast
var surface: SurfaceTracker

func same_level(overview: Node, f: int) -> bool:
	print("OVERVIEW: ", overview.height.F, " - F:", f)
	return f != 0 and f == overview.height.F

func is_same_floor(floors: TileMapLayer, overview: Node) -> bool:
	var ground: Node2D = deployment.walls.current
	var tile: Vector2 = surface.entity.position + ground.position

	var f: int = Tiling.extract(floors, Tiling.floor(tile))

	height.set_floor(f)
	return same_level(overview, height.F)

func _direct(overview: Node) -> Vector2i:
	return overview.directions.eyes.direction

func can_land(overview: Node) -> bool:
	return deployment.can_deploy(self, overview)

func can_deploy(floors: TileMapLayer, overview: Node) -> bool:
	return deployment.can_deploy(self, overview, floors)