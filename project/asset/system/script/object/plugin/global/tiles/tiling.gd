extends RefCounted

class_name Tiling

enum { LEVEL = 0, FLOOR = 1 }
enum Atlas { START = 1, SIZE = 5 }

static var _data: Array[String] = ["P", "F"]
static var _none: Array[int] = [0, 0]

const ATLAS_SIZE: int = 5
const ATLAS_START: int = 1

static func atlas(map: TileMapLayer, pos: Vector2) -> Dictionary:
	var coords: Vector2i = map.local_to_map(pos)
	var id: int = map.get_cell_source_id(coords)
	var result: Dictionary = {
		"name": "none", "cell": Vector2(-1, -1), "coords": coords
	}
	if id != -1:
		result.name = map.tile_set.get_source(id).resource_name
		result.cell = map.get_cell_atlas_coords(coords)
	#assert(id != -1, "Activator is not connected to logic")
	print("LAYER: ", map.name, " - ID: ", id, " - COORDS: ", coords)
	return result

#static func level(tile: Vector2) -> Dictionary:
#	return { "pos": tile, "data": "P", "none": 0 }

#static func floor(tile: Vector2) -> Dictionary:
#	return { "pos": tile, "data": "F", "none": 0 }
static func logic(cell: Vector2i) -> int:
	return cell.y * Atlas.SIZE + cell.x + Atlas.START

static func custom(map: TileMapLayer, coords: Vector2i, option: int) -> Variant:
	var tile: TileData = map.get_cell_tile_data(coords)
	var t: int = map.get_cell_source_id(coords)
	print("id: ", t)
	print("layer: ", map.name, ", local to map: ", coords, ", data: ", tile)

	return _none[option] if tile == null else tile.get_custom_data(_data[option])


static func extract(map: TileMapLayer, pos: Vector2, option: int) -> Variant:
	print("orig pos: ", pos)
	return custom(map, map.local_to_map(pos), option)
