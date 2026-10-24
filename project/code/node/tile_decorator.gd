class_name TileDecorator extends TileMapLayer

enum { M_LEVEL = 0, M_FLOOR = 1, M_BREAK = 2, SIZE = 5, TILE_DATA = 5, MOLD = 0, COORDS = 1 }

const data: String = "PFB"
var tile: PackedInt32Array = [0, 0]

func mold() -> int: return tile[MOLD]
func m_coords() -> int: return tile[COORDS]
func ground() -> TileDecorator: return id().atlas().type()

func nan_tile(saved: PackedInt32Array, from: int) -> TileDecorator:
	for i in range(0, 2): saved[from * TILE_DATA + i] = 0
	return self
func get_tile(saved: PackedInt32Array, from: int) -> TileDecorator:
	for i in range(0, 2): saved[from * TILE_DATA + i] = tile[i]
	return self
func set_tile(saved: PackedInt32Array, from: int) -> TileDecorator:
	for i in range(0, 5): tile[i] = saved[from * TILE_DATA + i]
	return self

func atlas(next: int = -1) -> TileDecorator:
	if next == -1: next = D.join8(get_cell_atlas_coords(D.map(tile[COORDS])))
	tile[MOLD] = D.to_byte(tile[MOLD], D.ATLAS, next)
	print("ID.AS.TP mold: ", D.byte4(tile[MOLD]))
	return self

func id(next: int = -1) -> TileDecorator:
	if next == -1: next = get_cell_source_id(D.map(tile[COORDS]))
	tile[MOLD] = D.to_byte(tile[MOLD], D.ID, next)
	#print("ID.AS.TP mold: ", D.byte4(tile[MOLD])) # print("map id: ", get_cell_source_id(D.map(tile[COORDS])), " - mold: ", mold(), " - id: ", get_cell_source_id(D.map(tile[COORDS])))
	return self

func type(next: int = -1) -> TileDecorator:
	if next == -1: next = get_cell_alternative_tile(D.map(tile[COORDS]))
	else: next = next << 2 | (tile[D.ALT] & 3)
	tile[MOLD] = D.to_short(tile[MOLD], D.ALT, next) # - 1
	print("ID.AS.TP mold: ", D.byte4(tile[MOLD]))
	return self

func alt(next: int) -> TileDecorator:  tile[D.ALT] = (tile[D.ALT] & ~3) | next; return self
func pos(p: Vector2) -> TileDecorator:
	tile[COORDS] = D.join(local_to_map(p))
	print("map coords: ", local_to_map(p), " of: ", p, " - mold: ", mold())
	return self
func coords(map_coords: int) -> TileDecorator: tile[COORDS] = map_coords; return self

func layer_name() -> String: return tile_set.get_source(tile[Action.ID]).resource_name
func busy() -> Array[Vector2i]: return get_used_cells_by_id(tile[Action.ID], D.map8(tile[Action.ATLAS]))
func paint() -> TileDecorator:
	set_cell(D.map(tile[COORDS]), D.byte(tile[MOLD], D.ID), D.map8(D.byte(tile[MOLD], D.ATLAS)))
	return self

func paint_alt() -> TileDecorator:
	set_cell(D.map(tile[COORDS]), D.byte(tile[MOLD], D.ID), D.map8(D.byte(tile[MOLD], D.ATLAS)), D.short(tile[MOLD], D.ALT))# + 1)
	return self

func erase() -> TileDecorator: erase_cell(D.map(tile[COORDS])); return self
func positioned() -> Vector2: return map_to_local(D.map(tile[COORDS]))
func extract(no: int) -> int:
	var at: TileData = get_cell_tile_data(D.map(tile[COORDS]))
	return 0 if at == null else at.get_custom_data(data[no])
