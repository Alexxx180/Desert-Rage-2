extends RefCounted

class_name Tile # Tile map Facade class

enum Atlas { LEVEL = 0, FLOOR = 1, SIZE = 5 }

static var _options: Array[Array] = [["P", 0], ["F", 0]]

static func _load(layer: TileMapLayer, map_coords: Vector2i) -> TileData:
	return layer.get_cell_tile_data(map_coords)

static func source(layer: TileMapLayer, map_coords: Vector2i) -> Vector2i:
	return layer.get_cell_atlas_coords(map_coords)

static func coordinate(layer: TileMapLayer, pos: Vector2) -> Vector2i:
	return layer.local_to_map(pos)

static func basis(layer: TileMapLayer, map_coords: Vector2i) -> Dictionary:
	return { "coords": map_coords, "id": layer.get_cell_source_id(map_coords) }

static func modify(tile_basis: Dictionary, layer: TileMapLayer) -> Dictionary:
	var id: int = tile_basis["id"]
	if id != -1:
		tile_basis.name = layer.tile_set.get_source(id).resource_name
		tile_basis.cell = source(map, tile_basis["coords"])
	return tile_basis

static func atlas_from_coords(layer: TileMapLayer, map_coords: Vector2i) -> Dictionary:
	var result: Dictionary = basis(layer, map_coords)
	result["cell"] = Vector2(-1, -1)
	result["name"] = "none"
	return modify(result, layer)

static func atlas(layer: TileMapLayer, pos: Vector2) -> Dictionary:
	var map_coords: Vector2i = coordinate(layer, pos)
	return atlas_data(layer, map_coords)

static func retile(layer: TileMapLayer, cells: Dictionary) -> void:
	layer.set_cell(cells["coords"], cells["id"], cells["atlas"]) # cells["cell"])


static func logic(cell: Vector2i) -> int:
	return cell.y * Atlas.FLOOR + cell.x + Atlas.SIZE

static func custom(layer: TileMapLayer, map_coords: Vector2i, no: int) -> Variant:
	var tile: TileData = _load(layer, map_coords)
	# print(", layer: ", map.name, ", map local: ", coords, ", data: ", tile)
	if tile == null: return _options[no][0]
	return tile.get_custom_data(_options[no][1])


static func extract(layer: TileMapLayer, pos: Vector2, option: int) -> Variant:
	var map_coords: Vector2i = coordinate(map, pos)
	return custom(layer, map_coords, option)
