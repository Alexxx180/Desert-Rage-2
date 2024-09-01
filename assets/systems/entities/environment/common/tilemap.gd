extends Node

class_name Tiler

const FLOOR_LAYER: int = 1
const TILE_SIZE: int = 64

@onready var tracking: Node = $tracking

func set_control_entity(entity: Node2D, velocity: Node, geometry: CollisionShape2D) -> void:
	tracking.entity = entity
	tracking.velocity = velocity
	tracking.set_contacts(geometry.shape.size)

func find_tile(map: TileMap) -> int:
	# print("DIRECTION: ", tracking.direction)
	var direction = tracking.direction
	var contact = tracking.contact
	if fmod(contact.x, TILE_SIZE) == 0 or fmod(contact.y, TILE_SIZE) == 0:
		contact += Vector2(direction.x * 0.1, direction.y * 0.1)
	return Tiler.get_tile(map, contact)

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
