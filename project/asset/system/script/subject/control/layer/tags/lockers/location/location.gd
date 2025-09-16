extends Node

@onready var storage: Node = $storage
@onready var search: Node = $search

func setup(execute: TileMapLayer) -> void:
	search.setup(execute, storage)

func activate(map_coords: Vector2i) -> void:
	search.activate(map_coords)

func set_lockers(tag: Vector2i, map_coords: Array[Vector2i]) -> void:
	var i: int = map_coords.size()
	print("TAG: ", tag)
	while i > 0:
		i -= 1
		var tile: Dictionary = search.atlas.get_atlas(map_coords[i], tag)
		match tile.atlas:
			Vector2i(0, 3), Vector2i(1, 3):
				storage.setup_plate(tile)
				map_coords.remove_at(i)
			Vector2i(0, 4), Vector2i(1, 4), Vector2i(3, 5):
				storage.setup_trigger(tile)
				map_coords.remove_at(i)
			Vector2i(0, 5), Vector2i(1, 5):
				storage.setup_lock(tile)
			Vector2i(2, 3), Vector2i(2, 4):
				storage.setup_eraser_lock(tile)
	storage.logic.connector[tag] = map_coords
