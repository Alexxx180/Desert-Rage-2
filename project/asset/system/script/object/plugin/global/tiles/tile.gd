extends RefCounted

class_name Tile # Map facade class

enum { LEVEL = 0, FLOOR = 1, BREAK = 2, SIZE = 5 }

static var _options: Array[Array] = [["P", 0], ["F", 0], ["B", 0]]

static func get_pos(layer: TileMapLayer, map_coords: Vector2i) -> Vector2:
	return layer.map_to_local(map_coords)

static func find(layer: TileMapLayer, position: Vector2) -> Vector2i:
	return layer.local_to_map(position)

static func used_cells(layer: TileMapLayer, atlas_cell: Vector2i, id: int = -1) -> Array[Vector2i]:
	return layer.get_used_cells_by_id(id, atlas_cell)

static func atlas_coords(layer: TileMapLayer, map_coords: Vector2i) -> Vector2i:
	return layer.get_cell_atlas_coords(map_coords)

static func paint(layer: TileMapLayer, cells: Dictionary) -> void:
	layer.set_cell(cells["coords"], cells["id"], cells["atlas"]) # cells["cell"])


static func basis(layer: TileMapLayer, map_coords: Vector2i) -> Dictionary:
	return { "coords": map_coords, "id": layer.get_cell_source_id(map_coords) }

static func modify(tile_basis: Dictionary, layer: TileMapLayer) -> Dictionary:
	if tile_basis["id"] == -1: return tile_basis
	tile_basis.name = layer.tile_set.get_source(tile_basis["id"]).resource_name
	tile_basis.atlas = atlas_coords(layer, tile_basis["coords"])
	return tile_basis

static func from_coords(layer: TileMapLayer, map_coords: Vector2i) -> Dictionary:
	var result: Dictionary = basis(layer, map_coords)
	result.atlas = Vector2(-1, -1)
	result.name = "none"
	return modify(result, layer)

static func from_pos(layer: TileMapLayer, pos: Vector2) -> Dictionary:
	var result: Dictionary = from_coords(layer, find(layer, pos))
	result.pos = pos
	return result


static func logic(cell: Vector2i) -> int:
	return cell.y * SIZE + FLOOR + cell.x

static func extract(layer: TileMapLayer, map_coords: Vector2i, no: int) -> Variant:
	var tile: TileData = layer.get_cell_tile_data(map_coords)
	# print(", layer: ", map.name, ", map local: ", coords, ", data: ", tile)
	if tile == null: return _options[no][1]
	return tile.get_custom_data(_options[no][0])
