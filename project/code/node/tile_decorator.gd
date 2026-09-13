class_name TileDecorator extends TileMapLayer

enum { LEVEL = 0, FLOOR = 1, BREAK = 2, SIZE = 5 }

const data: String = "PFB"

var tile: PackedInt32Array = [0, 0, 0, 0, 0]

func atlas(next: int = -1) -> TileDecorator:
	if next == -1:
		tile[WorldInteraction.ATLAS] = Def.join8(get_cell_atlas_coords(Def.map(tile[WorldInteraction.COORDS])))
	else:
		tile[WorldInteraction.ATLAS] = next
	return self

func id(next: int = -1) -> TileDecorator:
	tile[WorldInteraction.ID] = get_cell_source_id(Def.map(tile[WorldInteraction.COORDS])) if next == -1 else next
	return self

func type(next: int = -1) -> TileDecorator:
	if next == -1:
		var alt_id: int = get_cell_alternative_tile(Def.map(tile[WorldInteraction.COORDS])) - 1
		tile[WorldInteraction.TYPE] = alt_id >> 2
		tile[WorldInteraction.ALT] = alt_id & 3
	else:
		tile[WorldInteraction.TYPE] = next
	return self

func alt(next: int) -> TileDecorator:
	tile[WorldInteraction.ALT] = next
	return self

func pos(p: Vector2) -> TileDecorator:
	tile[WorldInteraction.COORDS] = Def.join(local_to_map(p))
	return self

func coords(map_coords: int) -> TileDecorator:
	tile[WorldInteraction.COORDS] = map_coords
	return self

func layer_name() -> String:
	return tile_set.get_source(tile[WorldInteraction.ID]).resource_name

func busy() -> Array[Vector2i]:
	return get_used_cells_by_id(tile[WorldInteraction.ID], Def.map8(tile[WorldInteraction.ATLAS]))

func paint() -> TileDecorator:
	set_cell(Def.map(tile[WorldInteraction.COORDS]), tile[WorldInteraction.ID], Def.map8(tile[WorldInteraction.ATLAS]))
	return self

func paint_alt() -> TileDecorator:
	set_cell(Def.map(tile[WorldInteraction.COORDS]), tile[WorldInteraction.ID], Def.map8(tile[WorldInteraction.ATLAS]), ((tile[WorldInteraction.TYPE] << 2) | tile[WorldInteraction.ALT]) + 1)
	return self

func erase() -> TileDecorator:
	erase_cell(Def.map(tile[WorldInteraction.COORDS]))
	return self

func position() -> Vector2:
	return map_to_local(Def.map(tile[WorldInteraction.COORDS]))

func extract(no: int) -> int:
	var at: TileData = get_cell_tile_data(Def.map(tile[WorldInteraction.COORDS]))
	return 0 if at == null else at.get_custom_data(data[no])
