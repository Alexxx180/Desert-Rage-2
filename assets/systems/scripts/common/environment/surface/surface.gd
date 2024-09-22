extends Node

@onready var tracking: Node = $tracking
@onready var tilemap: Node = $tilemap
@onready var floors: FloorsQueue = FloorsQueue.new()

func set_control_entity(entity: Node2D) -> void:
	tracking.set_control_entity(entity)

func find(space: DeploymentRaycast) -> void:
	var surface = space.surface.get_collider()
	var pos: Vector2 = tracking.center + space.walls.position
	var F: int = Tiler.get_tile(surface, pos)
	space.deploy.emit(F, pos)

func at_old_floor(_body: TileMap) -> void:
	floors.remove()

func at_new_floor(body: TileMap) -> void:
	floors.append(tilemap.find_tile(body, tracking))
