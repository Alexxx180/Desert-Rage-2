extends Node

@onready var balance: Node = $balance
@onready var height: Node = $height

var deployment: DeploymentRaycast
var surface: SurfaceTracker

func same_level(overview: Node) -> bool:
	return height.F != 0 and height.F == overview.height.F

func free_space(overview: Node) -> bool:
	var eyes: Node = overview.directions.eyes
	return deployment.can_deploy(eyes.direction)

func can_deploy(floors: TileMapLayer, overview: Node) -> bool:
	if not free_space(overview): return false

	var tile: Vector2 = surface.track(deployment.ground)
	var f: int = surface.find_floor(floors, tile)
	print("FIND: ", f)
	height.set_floor(surface.find_floor(floors, tile))
	print("HEIGHT: ", height.F, " - OVERVIEW: ", overview.height.F)
	return same_level(overview)
