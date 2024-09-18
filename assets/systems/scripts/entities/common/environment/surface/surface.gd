extends Node

signal on_floors(F: int, position: Vector2)

@onready var tracking: Node = $tracking
@onready var tilemap: Node = $tilemap
@onready var floors: FloorsQueue = FloorsQueue.new()

# func _is_same(body: Node2D) -> bool:
#	return body.get_instance_id() == get_instance_id()
func set_control_entity(entity: Node2D) -> void:
	tracking.set_control_entity(entity)

func find_surface(next: Vector2i, space: DeploymentRaycast) -> void:
	var f: int = 0
	var pos: Vector2 = next
	if pos != Vector2.ZERO and space.can_deploy(next):
		pos = space.walls.position
		f = Tiler.get_tile(space.surface.get_collider(),
			tracking.center + pos + space.half)
	on_floors.emit(f, pos)

func at_old_floor(body) -> void:
	if body is StaticBody2D or body is TileMap:
		floors.remove()

func at_new_floor(body) -> void:
	match body:
		StaticBody2D: floors.append(body.F) # StaticBody2D: not _is_same(body)
		TileMap: floors.append(tilemap.find_tile(body, tracking))
