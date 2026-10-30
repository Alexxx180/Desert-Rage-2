@tool
extends Node

@export_tool_button("Precalculate level logic tiles", "2DNodes")
var test = setup_coords # : Callable

@export var debug_tiles: PackedVector2Array = []
@export var branching_off: PackedInt32Array  # get difficulty from vault
@export var branching_on: PackedInt32Array # var casual_mode: bool = true; if casual_mode:

func add_branching(e: TileDecorator, pillars: PackedVector2Array, branch: PackedInt32Array) -> void:
	var no_tag: Vector2 = Vector2i(-1, -1); var e_null: bool = e == null
	for pillar in pillars:
		if e_null or (e.get_cell_atlas_coords(pillar) == no_tag):
			branch.append(pillar)

enum { CLUSTER = 64, LEVERS = 0, SOURCE, BUTTON, TRANSP,
	LEVERS_ID = (1<<Action.LEVER_OFF)|(1<<Action.LEVER_ON),
	SOURCE_ID = (1<<Action.SOURCE_OFF)|(1<<Action.SOURCE_ON),
	BUTTON_ID = (1<<Action.PLATE_OFF)|(1<<Action.PLATE_ON),
	TRANSP_ID = (1<<Action.TELEPORTS_OFF)|(1<<Action.PLACE),
	U_WALLS = (1<<U_WALL_OFF)|(1<<U_WALL_ON),
	D_WALLS = (1<<D_WALL_OFF)|(1<<D_WALL_ON),
	STANDS = (1<<STAND_OFF)|(1<<STAND_ON)
}

func setup_coords() -> void:
	var b: TileDecorator = get_node(^"../border")
	var e: TileDecorator = get_node(^"../execute")
	var g: TileDecorator = get_node(^"../group")

	branching_off = []; branching_on = []
	for n in [Action.U_PILLAR_OFF, Action.D_PILLAR_OFF]: add_branching(e, b.get_used_cells_by_id(Action.LOGIC, D.map8(n)), branching_off)
	for n in [Action.U_PILLAR_ON, Action.D_PILLAR_ON]: add_branching(e, b.get_used_cells_by_id(Action.LOGIC, D.map8(n)), branching_on)

	if e == null: return

	var header: PackedByteArray = []; var count: int = 0
	var access: PackedByteArray = []; var coords: PackedInt32Array = []
	var levers: PackedByteArray = []; var lcoord: PackedInt32Array = []
	var button: PackedByteArray = []; var bcoord: PackedInt32Array = []
	var source: PackedByteArray = []; var scoord: PackedInt32Array = []
	var transp: PackedByteArray = []; var tcoord: PackedInt32Array = []

	for y in range(0, T8):
		var tiles: PackedVector2Array = e.get_used_cells_by_id(Action.TAGS, D.map8(y))
		if tiles.size() == 0: break
		
		var search: int = -1
		var part_cluster: PackedInt32Array = [0]
		for x in range(0, tiles.size()):
			var c: int = D.join(tiles[x])
			if search != -1: part_cluster.push_back(c); continue

			var atlas: int = D.byte(b.coords(c).mold(), D.ATLAS)
			if D.m(atlas, LEVERS): search = LEVERS
			elif D.m(atlas, SOURCE): search = SOURCE
			elif D.m(atlas, BUTTON): search = BUTTON
			elif D.m(atlas, TRANSP): search = TRANSP
			else: part_cluster.push_back(c); continue

			part_cluster[0] = c

		match search:
			LEVERS: levers.append(count); lcoord.append_array(part_cluster)
			BUTTON: button.append(count); bcoord.append_array(part_cluster)
			SOURCE: source.append(count); scoord.append_array(part_cluster)
			TRANSP: transp.append(count); tcoord.append_array(part_cluster)

		count += tile.size()

	var htypes: Array[PackedInt32Array] = [levers, source, button, transp]; var sizes: int = 0
	var ctypes: Array[PackedInt32Array] = [lcoord, scoord, bcoord, tcoord]
	for i in range(0, len(types)):
		coords.append_array(ctypes[i])
		access.append_array(htypes[i])
		header[i] = sizes; sizes += types[i].size()

	g.access = access; g.coords = coords
	g.header = header
