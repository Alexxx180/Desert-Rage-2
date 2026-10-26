@tool
extends Node

@export var test_data: PackedStringArray# = [""]
@export_tool_button("Precalculate level logic", "2DNodes")
var test = precalculate_logic # : Callable

func precalculate_logic() -> void:
	test_data = ["123"]
	print("try to precalculate")

func resize_clusters() -> void:
	var execute: TileDecorator = get_node(^"execute")
	if execute == null: return
	
	var border: TileDecorator = get_node(^"border")
	var casual_mode: bool = true # get difficulty from vault
	if casual_mode:
		var platinum_off: PackedVector2Array = HUD.level.border.get_used_cells_by_id(Action.LOGIC, D.map8(Action.PLATINUM_OFF))
		
		var chests_off: PackedByteArray = [BRONZE_OFF, SILVER_OFF, GOLD_OFF, PLATINUM_OFF]
		var chests_on: PackedByteArray = [BRONZE_ON, SILVER_ON, GOLD_ON, PLATINUM_ON]
		for i in range(0, len(chests_on)):
			border.id(Action.LOGIC).atlas(chests_off[i])
			for coords in HUD.level.border.get_used_cells_by_id(Action.LOGIC, D.map8(chests_on[i])): border.coords(D.join(coords)).paint()
		
		border.id(Action.LOGIC).atlas(Action.PLATINUM_ON)
		for coords in platinum_off: HUD.level.border.coords(D.join(coords)).paint()
	
	var button: PackedInt32Array = []
	var lever: PackedInt32Array = []
	var source: PackedInt32Array = []
	var teleport: PackedInt32Array = []
	# TODO FIXME REWORK FOR PRECALCULATE
	if len(cluster) == 0: cluster.resize(CLUSTER)
	var count: int = 0
	for y in range(0, T8):
		var tiles: PackedVector2Array = HUD.level.execute.get_used_cells_by_id(Action.TAGS, D.map8(y))
		if tiles.size() == 0: break
		if count + tiles.size() > cluster.size(): cluster.resize(cluster.size() * 2)
		
		var search: bool = true
		for x in range(0, tiles.size()):
			cluster[count + x] = D.join(tiles[x])
			if search:
				search = false
				match HUD.level.border.coords(D.join(tiles[x])).tile[D.ATLAS]:
					LEVER_OFF, LEVER_ON: lever.append(D.of(tiles.size(), count))
					SOURCE_OFF, SOURCE_ON: source.append(D.of(tiles.size(), count))
					PLATE_OFF, PLATE_ON: button.append(D.of(tiles.size(), count))
					TELEPORT_ON, PLACE: teleport.append(D.of(tiles.size(), count))
					_: search = true
		count += tiles.size()
	var types: Array[PackedInt32Array] = [button, lever, source, teleport]
	access.clear()
	for i in range(0, len(types)):
		access.append_array(types[i])
		sizes[i] = types[i].size()
