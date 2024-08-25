extends Node

const FLOOR_LAYER: int = 3

@onready var tracking: Node = $tracking
# geometry.shape.size # CollisionObject2D:

func set_control_entity(entity: Node2D, geometry: CollisionShape2D) -> void:
	tracking.entity = entity
	tracking.set_contacts(geometry.shape.size)

func find_tile(map: TileMap) -> int:
	assert(tracking.direction != Vector2i.ZERO)

	var pos: Vector2 = tracking.contact

	print("POS: ", pos)
	var hovered_cell = map.local_to_map(pos)
	print("CELL: ", hovered_cell)
	var type_name = map.tile_set.get_custom_data_layer_by_name("F")
	print(type_name)
	var data = map.get_cell_tile_data(FLOOR_LAYER, hovered_cell)
	print("CUSTOM DATA: ", data.get_custom_data("F"))
	return data.get_custom_data("F")
