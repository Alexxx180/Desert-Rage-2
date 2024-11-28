extends Node

const SOURCE_ATLAS: int = 1

var locks: Dictionary = {} # Vector2, StaticBody2D

func add_lock(id: int, activator: Vector2, lock: StaticBody2D) -> void:
	if id != SOURCE_ATLAS: return

	if not locks.has(activator):
		locks[activator] = []

	print("ADD LOCK: ", lock.name)
	locks[activator].push_back(lock)

func activate(id: int, activator: Vector2) -> void:
	if id != SOURCE_ATLAS or not locks.has(activator):
		return

	for lock in locks[activator]:
		lock.activate()
