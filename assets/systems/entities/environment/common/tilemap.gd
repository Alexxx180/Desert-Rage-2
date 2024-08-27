extends Node

const FLOOR_LAYER: int = 1

@onready var tracking: Node = $tracking
# geometry.shape.size # CollisionObject2D:

func set_control_entity(entity: Node2D, geometry: CollisionShape2D) -> void:
	tracking.entity = entity
	tracking.set_contacts(geometry.shape.size)

func find_tile(map: TileMap) -> int:
	assert(tracking.direction != Vector2i.ZERO)
	var cell = map.local_to_map(tracking.contact)
	var tile = map.get_cell_tile_data(FLOOR_LAYER, cell)
	return tile.get_custom_data("F")
