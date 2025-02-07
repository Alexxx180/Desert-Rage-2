extends Node

var locks: Dictionary = {} # String, Dictionary[Vector2i, Dictionary]

func activate(execute: TileMapLayer) -> void:
	# transition: Dictionary) -> void:
	var map: Dictionary = {}
	if !check.available(map, transition): return

	var cell: Vector2i = map.passage.cell
	if not locks["trigger"].has(cell):
		print("no triggers found", cell)

	var connector_cell: Vector2i = locks["trigger"][cell]["connector"]

	for lock in locks["connector"][connector_cell]:
		var machine: Dictionary = locks["machine"][lock]
		var atlas_cell: Vector2i = machine["atlas"]

		if atlas_cell.x % 2 == 0:
			atlas_cell.x += 1
		else:
			atlas_cell.x -= 1

		machine["atlas"] = atlas_cell
		Tile.retile(execute, machine)

func connect_activators(execute: TileMapLayer, connector_cell: Vector2i, used_cells: Array[Vector2i]) -> void:
	var i: int = used_cells.size()
	while i > 0:
		i -= 1
		var cell: Vector2i = used_cells[i]
		var atlas_cell: Vector2i = get_cell_atlas_coords(cell)

		match atlas_cell:
			Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1):
				var atlas: Dictionary = Tile.atlas_from_coords(execute, cell)
				assert(atlas["name"] != "none", "Tags: no executable connection")

				atlas["connector"] = connector_cell
				locks["trigger"][cell] = atlas
				used_cells.remove(i)
			Vector2i(2, 0), Vector2i(3, 0), Vector2i(2, 1), Vector2i(3, 1):
				locks["machine"][cell] = Tile.atlas_from_coords(execute, cell)
				locks["machine"][cell]["atlas"] = atlas_cell
			_: pass
	locks["connector"][connector_cell] = used_cells

func add_lock(execute: TileMapLayer, tags: TileMapLayer) -> void:
	var used_cells: Array[Vector2i]
	for x in range(5):
		for y in range(5):
			var atlas_cell: Vector2i = Vector2i(x, y)
			used_cells = tags.get_used_cells_by_id(SOURCE, atlas_cell)
			connect_activators(execute, atlas_cell, used_cells)

"""
func add_lock(tile: Dictionary, lock: StaticBody2D) -> void:
	if tile.name != SOURCE_ATLAS: return

	if not locks.has(tile.cell):
		locks[tile.cell] = []

	#print("ADD LOCK: ", lock.name)
	locks[tile.cell].push_back(lock)

func activate(tile: Dictionary) -> void:
	if tile.name != SOURCE_ATLAS: return
	if not locks.has(tile.cell): return 

	for lock in locks[tile.cell]:
		lock.activate()
# """
