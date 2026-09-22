class_name TileDecorator extends TileMapLayer

enum { LEVEL = 0, FLOOR = 1, BREAK = 2, SIZE = 5, TILE_DATA = 5 }

const data: String = "PFB"

var tile: PackedInt32Array = [0, 0, 0, 0, 0]

func get_tile(saved: PackedInt32Array, from: int) -> void: for i in range(0, 5): saved[from * TILE_DATA + i] = tile[i]
func set_tile(saved: PackedInt32Array, from: int) -> void: for i in range(0, 5): tile[i] = saved[from * TILE_DATA + i]

func atlas(next: int = -1) -> TileDecorator:
	if next == -1:
		tile[HUD.ATLAS] = Def.join8(get_cell_atlas_coords(Def.map(tile[HUD.COORDS])))
	else:
		tile[HUD.ATLAS] = next
	return self

func id(next: int = -1) -> TileDecorator:
	tile[HUD.ID] = get_cell_source_id(Def.map(tile[HUD.COORDS])) if next == -1 else next
	return self

func type(next: int = -1) -> TileDecorator:
	if next == -1:
		var alt_id: int = get_cell_alternative_tile(Def.map(tile[HUD.COORDS])) - 1
		tile[HUD.TYPE] = alt_id >> 2
		tile[HUD.ALT] = alt_id & 3
	else:
		tile[HUD.TYPE] = next
	return self

func alt(next: int) -> TileDecorator:
	tile[HUD.ALT] = next
	return self

func pos(p: Vector2) -> TileDecorator:
	tile[HUD.COORDS] = Def.join(local_to_map(p))
	return self

func coords(map_coords: int) -> TileDecorator:
	tile[HUD.COORDS] = map_coords
	return self

func layer_name() -> String:
	return tile_set.get_source(tile[HUD.ID]).resource_name

func busy() -> Array[Vector2i]:
	return get_used_cells_by_id(tile[HUD.ID], Def.map8(tile[HUD.ATLAS]))

func paint() -> TileDecorator:
	set_cell(Def.map(tile[HUD.COORDS]), tile[HUD.ID], Def.map8(tile[HUD.ATLAS]))
	return self

func paint_alt() -> TileDecorator:
	set_cell(Def.map(tile[HUD.COORDS]), tile[HUD.ID], Def.map8(tile[HUD.ATLAS]), ((tile[HUD.TYPE] << 2) | tile[HUD.ALT]) + 1)
	return self

func erase() -> TileDecorator:
	erase_cell(Def.map(tile[HUD.COORDS]))
	return self

func position() -> Vector2:
	return map_to_local(Def.map(tile[HUD.COORDS]))

func extract(no: int) -> int:
	var at: TileData = get_cell_tile_data(Def.map(tile[HUD.COORDS]))
	return 0 if at == null else at.get_custom_data(data[no])
