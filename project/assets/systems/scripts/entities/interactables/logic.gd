extends Node

var locks: Dictionary = {} # Vector2, StaticBody2D

func add_lock(activator: Vector2, lock: StaticBody2D) -> void:
	if not locks.has(activator):
		locks[activator] = []
	print("ADD LOCK: ", lock.name)
	locks[activator].push_back(lock)

func activate(activator: Vector2) -> void:
	for lock in locks[activator]:
		lock.activate()
