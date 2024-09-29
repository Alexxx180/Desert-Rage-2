extends Node

@onready var tracking: Node = $tracking
@onready var tilemap: Node = $tilemap
@onready var floors: FloorsQueue = FloorsQueue.new()

func find(space: DeploymentRaycast) -> void:
	var surface = space.surface.get_collider()
	var pos: Vector2 = tracking.get_position(space)
	var F: int = Tiler.get_tile(surface, pos)
	space.deploy.emit(F, pos)

func at_old_floor(_body: TileMapLayer) -> void:
	floors.remove()

func at_new_floor(walls: TileMapLayer) -> void:
	floors.append(tilemap.find_tile(walls.floors, tracking))
