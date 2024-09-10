extends Node

class_name Tiler

const FLOOR_LAYER: int = 1
const TILE_SIZE: int = 64

static func get_floor(tile: TileData) -> int:
	return 0 if tile == null else tile.get_custom_data("F")

static func print_c(contact, cell, tile) -> void:
	print("CONTACT: ", contact)
	print("CELL: ", cell)
	print("TILE: ", tile)

static func get_tile(map: TileMap, contact: Vector2) -> int:
	var cell: Vector2i = map.local_to_map(contact)
	var tile: TileData = map.get_cell_tile_data(FLOOR_LAYER, cell)
	#print_c(contact, cell, tile)
	return get_floor(tile)

@onready var tracking: Node = $tracking

func set_control_entity(entity: Node2D, velocity: Node, geometry: CollisionShape2D) -> void:
	tracking.entity = entity
	tracking.velocity = velocity
	tracking.set_contacts(geometry.shape.size)

func find_tile(map: TileMap) -> int:
	var direction: Vector2i = tracking.direction
	var contact: Vector2 = tracking.contact

	for axis in [Vector2.AXIS_X, Vector2.AXIS_Y]:
		if fmod(contact[axis], TILE_SIZE) == 0:
			contact[axis] += direction[axis] * 0.1

	return Tiler.get_tile(map, contact)


