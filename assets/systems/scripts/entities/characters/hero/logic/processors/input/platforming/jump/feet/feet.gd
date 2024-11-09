extends Node

@onready var balance: Node = $balance
@onready var height: Node = $height

var deployment: DeploymentRaycast
var surface: SurfaceTracker

func _same_level(overview: Node) -> bool:
	return height.F != 0 and height.F == overview.height.F

func is_same_floor(floors: TileMapLayer, overview: Node) -> bool:
	var tile: Vector2 = surface.track(deployment.walls.current)
	height.set_floor(surface.find_floor(floors, tile))
	return _same_level(overview)

func _direct(overview: Node) -> Vector2i:
	return overview.directions.eyes.direction

func can_land(overview: Node) -> bool:
	return deployment.can_deploy(self, overview)

func can_deploy(floors: TileMapLayer, overview: Node) -> bool:
	return deployment.can_deploy(self, overview, floors)
