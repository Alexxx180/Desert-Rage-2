class_name TileDecorator extends TileMapLayer

enum { LEVEL = 0, FLOOR = 1, BREAK = 2, SIZE = 5 }

var tile: PackedInt32Array = [0, 0, 0, 0, 0]
var data: PackedStringArray = ["P", "F", "B"]

func set_chip(node: Node2D) -> TileDecorator:
	node.position = map_to_local(Def.to256(tile[Def.TILE]))
	return self

func atlas(next: int = -1) -> TileDecorator:
	tile[Def.TILE] = next
	if next == -1: tile[Def.TILE] = Def.from256(get_atlas())
	return self

func id(next: int = -1) -> TileDecorator:
	tile[Def.ID] = next
	if next == -1: tile[Def.ID] = get_cell_source_id(Def.to256(tile[Def.COORDS]))
	return self

func type(next: int) -> TileDecorator:
	tile[Def.TYPE] = next
	if next == -1:
		var alt_id: int = get_cell_alternative_tile(Def.to256(tile[Def.COORDS]))
		tile[Def.TYPE] = alt_id >> 2
		tile[Def.ALT] = alt_id & 4
	return self

func alt(next: int) -> TileDecorator:
	tile[Def.ALT] = next
	return self

func pos(p: Vector2) -> TileDecorator:
	tile[Def.COORDS] = Def.from256(local_to_map(p))
	return self

func coords(map_coords: Vector2i) -> TileDecorator:
	tile[Def.COORDS] = Def.from256(map_coords)
	return self

func layer_name() -> String:
	return tile_set.get_source(tile[Def.ID]).resource_name

func busy() -> Array[Vector2i]:
	return get_used_cells_by_id(tile[Def.ID], Def.to256(tile[Def.TILE]))

func get_atlas() -> Vector2i:
	return get_cell_atlas_coords(Def.to256(tile[Def.COORDS]))

func paint() -> TileDecorator:
	set_cell(Def.to256(tile[Def.COORDS]), tile[Def.ID], Def.to256(tile[Def.TILE]))
	return self

func paint_alt() -> TileDecorator: return paint_on(Def.to256(tile[Def.COORDS]))

func paint_on(_coords: Vector2i) -> TileDecorator:
	set_cell(_coords, tile[Def.ID], Def.to256(tile[Def.TILE]), tile[Def.TYPE] + tile[Def.ALT])
	return self

func erase() -> TileDecorator:
	erase_cell(Def.to256(tile[Def.COORDS]))
	return self

func extract(no: int) -> int:
	var at: TileData = get_cell_tile_data(Def.to256(tile[Def.COORDS]))
	return 0 if at == null else at.get_custom_data(data[no])
