extends Node

const SOURCE: int = 2

@onready var check = $check
var locks: Dictionary = {} # String, Dictionary[Vector2i, Dictionary]

func deactivate(level: Dictionary) -> void:
	var map: Dictionary = check.available(level)
	if map.is_empty(): return

	var cell: Vector2i = map.passage.cell
	assert(locks["trigger"].has(cell), "no trigger found")
	
	locks.trigger[cell]["count"] -= 1
	if locks.trigger[cell]["count"] == 0:
		activate(level)

func press_button(level: Dictionary) -> void:
	var map: Dictionary = check.available(level)
	if map.is_empty(): return

	var cell: Vector2i = map.passage.cell
	assert(locks["trigger"].has(cell), "no trigger found")
	
	locks.trigger[cell]["count"] += 1
	if locks.trigger[cell]["count"] == 1:
		activate(level)

func activate(level: Dictionary) -> void:
	var map: Dictionary = check.available(level)
	if map.is_empty(): return

	var cell: Vector2i = map.passage.cell
	assert(locks["trigger"].has(cell), "no trigger found")

	var connector_cell: Vector2i = locks["trigger"][cell]["connector"]
	for lock in locks["connector"][connector_cell]:
		var machine: Dictionary = locks["machine"][lock]
		var atlas_cell: Vector2i = machine["atlas"]

		if atlas_cell.x % 2 == 0:
			atlas_cell.x += 1
		else:
			atlas_cell.x -= 1

		machine["atlas"] = atlas_cell
		Tile.paint(level.execute, machine)

func connect_activators(execute: TileMapLayer, connector_cell: Vector2i, used_cells: Array[Vector2i]) -> void:
	var i: int = used_cells.size()
	while i > 0:
		i -= 1
		var cell: Vector2i = used_cells[i]
		var atlas: Dictionary = Tile.from_coords(execute, cell)
		assert(atlas["name"] != "none", "Tags: no executable connection")
		var atlas_coords: Vector2i = execute.get_cell_atlas_coords(cell)
		match atlas_coords:
			Vector2i(0, 0), Vector2i(1, 0):
				atlas["connector"] = connector_cell
				locks["trigger"][cell] = atlas
				locks["trigger"][cell]["count"] = atlas_coords.x
				used_cells.remove_at(i)
			Vector2i(0, 1), Vector2i(1, 1):
				atlas["connector"] = connector_cell
				locks["trigger"][cell] = atlas
				used_cells.remove_at(i)
			Vector2i(2, 0), Vector2i(3, 0), Vector2i(2, 1), Vector2i(3, 1):
				locks["machine"][cell] = atlas
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
