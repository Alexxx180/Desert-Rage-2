extends Node

@onready var balance: Node = $balance
@onready var deployment: Node = $position
@onready var height: Node = $height

var space: DeploymentRaycast
var surface: SurfaceTracker

func same_level(overview: Node) -> bool:
	return height.F != 0 and height.F == overview.height.F

func free_space(overview: Node) -> bool:
	var eyes: Node = overview.directions.eyes
	if not space.can_deploy(eyes.direction): return false

	deployment.set_position(surface.track(space.ground))
	return true

func can_deploy(floors: TileMapLayer, overview: Node) -> bool:
	if not free_space(overview): return false

	height.set_floor(surface.find_floor(floors, deployment.position))
	return same_level(overview)
