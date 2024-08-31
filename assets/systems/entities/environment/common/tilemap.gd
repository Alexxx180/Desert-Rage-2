extends Node

class_name Tiler

const FLOOR_LAYER: int = 1

@onready var tracking: Node = $tracking

func set_control_entity(entity: Node2D, geometry: CollisionShape2D) -> void:
	tracking.entity = entity
	tracking.set_contacts(geometry.shape.size)

func find_tile(map: TileMap) -> int:
	return Tiler.get_tile(map, tracking.contact)

static func get_floor(tile: TileData) -> int:
	return 0 if tile == null else tile.get_custom_data("F")

static func get_tile(map: TileMap, contact: Vector2) -> int:
	var cell: Vector2i = map.local_to_map(contact)
	print("CELL: ", cell)
	var tile: TileData = map.get_cell_tile_data(FLOOR_LAYER, cell)
	return get_floor(tile)
