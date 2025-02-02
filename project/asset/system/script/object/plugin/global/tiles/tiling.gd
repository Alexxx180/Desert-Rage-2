extends RefCounted

class_name Tiling # Tile map Facade class

enum Atlas { LEVEL = 0, FLOOR = 1, SIZE = 5 }

static var _options: Array[Array] = [["P", 0], ["F", 0]]

static func _load(map: TileMapLayer, coords: Vector2i) -> TileData:
	return map.get_cell_tile_data(coords)

static func source(map: TileMapLayer, coords: Vector2i) -> Vector2i:
	return map.get_cell_atlas_coords(coords)

static func coordinate(map: TileMapLayer, pos: Vector2) -> Vector2i:
	return map.local_to_map(pos)

static func basis(map: TileMapLayer, coords: Vector2i) -> Dictionary:
	return { "coords": coords, "id": map.get_cell_source_id(coords) }

static func modify(map: TileMapLayer, tile_basis: Dictionary) -> Dictionary:
	var id: int = tile_basis["id"]
	if id != -1:
		tile_basis.name = map.tile_set.get_source(id).resource_name
		tile_basis.cell = source(map, tile_basis["coords"])
	return tile_basis


static func atlas(map: TileMapLayer, pos: Vector2) -> Dictionary:
	var result: Dictionary = basis(map, coordinate(map, pos))
	result["cell"] = Vector2(-1, -1)
	result["name"] = "none"
	return modify(map, result)

static func retile(map: TileMapLayer, cells: Dictionary) -> void:
	map.set_cell(cells["coords"], cells["id"], cells["cell"])


static func logic(cell: Vector2i) -> int:
	return cell.y * Atlas.FLOOR + cell.x + Atlas.SIZE

static func custom(map: TileMapLayer, coords: Vector2i, no: int) -> Variant:
	var tile: TileData = _load(map, coords) ; var option: Array = _options[no]
	# print(", layer: ", map.name, ", map local: ", coords, ", data: ", tile)
	return option[1] if tile == null else tile.get_custom_data(option[0])


static func extract(map: TileMapLayer, pos: Vector2, option: int) -> Variant:
	return custom(map, coordinate(map, pos), option)
