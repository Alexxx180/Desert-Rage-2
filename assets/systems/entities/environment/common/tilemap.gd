extends Node

const FLOOR_LAYER: int = 1

@onready var tracking: Node = $tracking
# geometry.shape.size # CollisionObject2D:

func set_control_entity(entity: Node2D, geometry: CollisionShape2D) -> void:
	tracking.entity = entity
	tracking.set_contacts(geometry.shape.size)

func get_floor(tile: TileData) -> int:
	return 0 if tile == null else tile.get_custom_data("F")

func find_tile(map: TileMap) -> int:
	var cell: Vector2i = map.local_to_map(tracking.contact)
	print("CELL: ", cell)
	var tile: TileData = map.get_cell_tile_data(FLOOR_LAYER, cell)
	return get_floor(tile)
