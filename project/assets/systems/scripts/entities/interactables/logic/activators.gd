extends Node

const SOURCE_ATLAS: String = "logic"

var locks: Dictionary = {} # Vector2, StaticBody2D

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
