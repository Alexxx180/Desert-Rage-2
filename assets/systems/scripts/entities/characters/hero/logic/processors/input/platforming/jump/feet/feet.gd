extends Node

@onready var balance: Node = $balance
@onready var height: Node = $height

var deployment: DeploymentRaycast
var surface: SurfaceTracker

func _same_level(overview: Node) -> bool:
	return height.F != 0 and height.F == overview.height.F

func free_space(overview: Node) -> bool:
	var eyes: Node = overview.directions.eyes
	return deployment.can_deploy(eyes.direction)

func is_same_floor(floors: TileMapLayer, overview: Node) -> bool:
	var tile: Vector2 = surface.track(deployment.walls.current)
	height.set_floor(surface.find_floor(floors, tile))
	return _same_level(overview)

func can_deploy(floors: TileMapLayer, overview: Node) -> bool:
	if not free_space(overview): return false

	return deployment.walls.are_ledges(self, floors, overview)
	#var tile: Vector2 = surface.track(deployment.walls.current)
	#height.set_floor(surface.find_floor(floors, tile))
	#return same_level(overview)
