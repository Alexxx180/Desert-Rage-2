class_name TileDecorator extends TileMapLayer

enum { LEVEL = 0, FLOOR = 1, BREAK = 2, SIZE = 5, TILE_DATA = 5 }

const data: String = "PFB"

var tile: PackedInt32Array = [0, 0, 0, 0, 0]

func nan_tile(saved: PackedInt32Array, from: int) -> void: for i in range(0, 5): saved[from * TILE_DATA + i] = 0
func get_tile(saved: PackedInt32Array, from: int) -> void: for i in range(0, 5): saved[from * TILE_DATA + i] = tile[i]
func set_tile(saved: PackedInt32Array, from: int) -> TileDecorator:
	for i in range(0, 5): tile[i] = saved[from * TILE_DATA + i]
	return self

func atlas(next: int = -1) -> TileDecorator:
	if next == -1:
		tile[Action.ATLAS] = Def.join8(get_cell_atlas_coords(Def.map(tile[Action.COORDS])))
	else:
		tile[Action.ATLAS] = next
	return self

func id(next: int = -1) -> TileDecorator:
	tile[Action.ID] = get_cell_source_id(Def.map(tile[Action.COORDS])) if next == -1 else next
	return self

func type(next: int = -1) -> TileDecorator:
	if next == -1:
		var alt_id: int = get_cell_alternative_tile(Def.map(tile[Action.COORDS])) - 1
		tile[Action.TYPE] = alt_id >> 2
		tile[Action.ALT] = alt_id & 3
	else:
		tile[Action.TYPE] = next
	return self

func alt(next: int) -> TileDecorator:
	tile[Action.ALT] = next
	return self

func pos(p: Vector2) -> TileDecorator:
	tile[Action.COORDS] = Def.join(local_to_map(p))
	return self

func coords(map_coords: int) -> TileDecorator:
	tile[Action.COORDS] = map_coords
	return self

func layer_name() -> String:
	return tile_set.get_source(tile[Action.ID]).resource_name

func busy() -> Array[Vector2i]:
	return get_used_cells_by_id(tile[Action.ID], Def.map8(tile[Action.ATLAS]))

func paint() -> TileDecorator:
	set_cell(Def.map(tile[Action.COORDS]), tile[Action.ID], Def.map8(tile[Action.ATLAS]))
	return self

func paint_alt() -> TileDecorator:
	set_cell(Def.map(tile[Action.COORDS]), tile[Action.ID], Def.map8(tile[Action.ATLAS]), ((tile[Action.TYPE] << 2) | tile[Action.ALT]) + 1)
	return self

func erase() -> TileDecorator:
	erase_cell(Def.map(tile[Action.COORDS]))
	return self

func position() -> Vector2:
	return map_to_local(Def.map(tile[Action.COORDS]))

func extract(no: int) -> int:
	var at: TileData = get_cell_tile_data(Def.map(tile[Action.COORDS]))
	return 0 if at == null else at.get_custom_data(data[no])
