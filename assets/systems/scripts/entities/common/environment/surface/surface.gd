extends Node

signal on_floors(F: int, position: Vector2)

@onready var tracking: Node = $tracking
@onready var tilemap: Node = $tilemap
@onready var floors: FloorsQueue = FloorsQueue.new()

func set_control_entity(entity: Node2D) -> void:
	tracking.set_control_entity(entity)

func find_surface(next: Vector2i, space: DeploymentRaycast) -> void:
	var f: int = 0
	var pos: Vector2 = next
	if pos != Vector2.ZERO and space.can_deploy(next):
		pos = space.walls.position
		# var floor_pos: Vector2 = tracking.center + space.contact()
		var surface = space.surface.get_collider()
		f = Tiler.get_tile(surface, pos)
	on_floors.emit(f, pos)

func at_old_floor(_body: TileMap) -> void:
	floors.remove()

func at_new_floor(body: TileMap) -> void:
	floors.append(tilemap.find_tile(body, tracking))
	# StaticBody2D: not _is_same(body)
