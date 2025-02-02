extends Node

const SOURCE_ATLAS: String = "logic"
const SOURCE: int = 2

var check: Node = $check

#var locks: Dictionary = {} # Vector2, StaticBody2D
var activators: Dictionary = { "button": {}, "lever": {} }

func switch(type: String, map: Dictionary) -> void:
	var offset: int = 2
	var toggle: Dictionary = activators[type][map.pos]
	toggle["state"] = !toggle["state"]
	var on: int = 1 if toggle["state"] else 0
	var execute: TileMapLayer

	for lock in toggle["locks"]:
		lock["cell"].x = on + offset
		Tiling.retile(layer, lock)

	Tiling.retile(execute, toggle[])

func activate(transition: Dictionary) -> void:
	var map: Dictionary = {}
	if !check.available(map, transition): return
	
	match map.passage.cell:
		Vector2i(0, 0), Vector2i(0, 1):
			switch("button", map)
		Vector2i(1, 0), Vector2i(1, 1):
			switch("lever", map)
		_: pass

func add_lock(execute: TileMapLayer, tags: TileMapLayer) -> void:
	var cell: Vector2i
	var activator: Array[Vector2i]
	var lock: Array[Vector2i]

	for x in range(5):
		activator = []
		lock = []
		for y in range(5):
			cell = tags.get_used_cells_by_id(SOURCE, Vector2i(x, y))
			lock.add()
			assert(activator.size() > 1, "Two activators connected to one bus!")
	pass

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
