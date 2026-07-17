class_name TileDecorator extends TileMapLayer

enum { LEVEL = 0, FLOOR = 1, BREAK = 2, SIZE = 5 }

const data: String = "PFB"

var tile: PackedInt32Array = [0, 0, 0, 0, 0]

func atlas(next: int = -1) -> TileDecorator:
	if next == -1:
		tile[Def.ATLAS] = Def.of8(get_cell_atlas_coords(Def.tomap(tile[Def.COORDS])))
	else:
		tile[Def.ATLAS] = next
	return self

func id(next: int = -1) -> TileDecorator:
	tile[Def.ID] = get_cell_source_id(Def.tomap(tile[Def.COORDS])) if next == -1 else next
	return self

func type(next: int = -1) -> TileDecorator:
	if next == -1:
		var alt_id: int = get_cell_alternative_tile(Def.tomap(tile[Def.COORDS])) - 1
		tile[Def.TYPE] = alt_id >> 2
		tile[Def.ALT] = alt_id & 3
	else:
		tile[Def.TYPE] = next
	return self

func alt(next: int) -> TileDecorator:
	tile[Def.ALT] = next
	return self

func pos(p: Vector2) -> TileDecorator:
	tile[Def.COORDS] = Def.ofmap(local_to_map(p))
	return self

func coords(map_coords: int) -> TileDecorator:
	tile[Def.COORDS] = map_coords
	return self

func layer_name() -> String:
	return tile_set.get_source(tile[Def.ID]).resource_name

func busy() -> Array[Vector2i]:
	return get_used_cells_by_id(tile[Def.ID], Def.to8(tile[Def.ATLAS]))

func paint() -> TileDecorator:
	set_cell(Def.tomap(tile[Def.COORDS]), tile[Def.ID], Def.to8(tile[Def.ATLAS]))
	return self

func paint_alt() -> TileDecorator:
	set_cell(Def.tomap(tile[Def.COORDS]), tile[Def.ID], Def.to8(tile[Def.ATLAS]), ((tile[Def.TYPE] << 2) | tile[Def.ALT]) + 1)
	return self

func erase() -> TileDecorator:
	erase_cell(Def.tomap(tile[Def.COORDS]))
	return self

func position() -> Vector2:
	return map_to_local(Def.tomap(tile[Def.COORDS]))

func extract(no: int) -> int:
	var at: TileData = get_cell_tile_data(Def.tomap(tile[Def.COORDS]))
	return 0 if at == null else at.get_custom_data(data[no])
