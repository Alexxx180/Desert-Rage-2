extends Node

const SOURCE_ATLAS: String = "logic"

var check: Node = $check

#var locks: Dictionary = {} # Vector2, StaticBody2D
var activators: Dictionary = { "button": {}, "lever": {} }

func switch(type: String, map: Dictionary) -> void:
	var offset: int = 2
	var toggle: Dictionary = activators[type][map.pos]
	toggle["state"] = !toggle["state"]
	var on: int = 1 if toggle["state"] else 0
	var layer: TileMapLayer

	for lock in toggle["locks"]:
		lock["cell"].x = on + offset
		Tiling.retile(layer, lock)

	Tiling.retile(layer, toggle[])

func activate(transition: Dictionary) -> void:
	var map: Dictionary = {}
	if !check.available(map, transition): return
	
	match map.passage.cell:
		Vector2i(0, 0), Vector2i(0, 1):
			switch("button", map)
		Vector2i(1, 0), Vector2i(1, 1):
			switch("lever", map)
		_: pass

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
