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


static func basis(layer: TileMapLayer, map_coords: Vector2i, id: int = -1) -> Dictionary:
	return { "coords": map_coords, "id": layer.get_cell_source_id(map_coords) if id == -1 else id }

static func switch(from: Dictionary, to: Vector2i, layer: TileMapLayer) -> void:
	if to.x != 0: from.atlas.x += to.x if from.atlas.x % (to.x + 1) == 0 else -to.x
	if to.y != 0: from.atlas.y += to.y if from.atlas.y % (to.y + 1) == 0 else -to.y
	paint(layer, from)

static func modify(tile_basis: Dictionary, layer: TileMapLayer) -> Dictionary:
	if tile_basis.id == -1: return tile_basis
	tile_basis.name = layer.tile_set.get_source(tile_basis.id).resource_name
	tile_basis.atlas = atlas_coords(layer, tile_basis.coords)
	print("ID: ", tile_basis.id, " - C-COORDS: ", tile_basis.coords, " - ATLAS: ", tile_basis.atlas)
	return tile_basis

static func from_coords(layer: TileMapLayer, map_coords: Vector2i, id: int = -1) -> Dictionary:
	var result: Dictionary = basis(layer, map_coords, id)
	result.atlas = Vector2(-1, -1)
	result.name = "none"
	return modify(result, layer)

static func from_pos(layer: TileMapLayer, pos: Vector2) -> Dictionary:
	var result: Dictionary = from_coords(layer, find(layer, pos))
	result.pos = pos
	return result

static func logic_no(cell: Vector2i, size: int = SIZE) -> int:
	return cell.y * size + FLOOR + cell.x

static func extract_at_pos(layer: TileMapLayer, pos: Vector2, no: int) -> Variant:
	var map_coords: Vector2i = Tile.find(layer, pos)
	return Tile.extract(layer, map_coords, no)

static func extract(layer: TileMapLayer, map_coords: Vector2i, no: int) -> Variant:
	var tile: TileData = layer.get_cell_tile_data(map_coords)
	# print(", layer: ", map.name, ", map local: ", coords, ", data: ", tile)
	if tile == null: return _options[no][1]
	return tile.get_custom_data(_options[no][0])
