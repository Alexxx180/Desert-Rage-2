extends Node

signal finish_combo(keys: Array[String])
signal enter_keys(keys: Array[String])

var mode: Node
var store: Node:
	get: return mode.input.store

#func reset() -> void: group = 0
#func next() -> int: return group + 1
func clear() -> void: mode.type.clear()

func form(count: int) -> Array:
	var unit: Array = []
	unit.resize(count)
	unit.fill(Defaults.INT)
	return unit

func store_code(element: Array, code: int) -> void:
	store.sets(element, mode.input.place, code)

func store_next(code: int) -> void:
	store.sets(store, store.next, code)

func store_last(code: int) -> void:
	store_code(store.last, code)
	enter(store.next)

func enter(codes: Array, input: Signal = enter_keys) -> void:
	input.emit(mode.translate(codes))

func finish(codes: Array) -> void: enter(codes, finish_combo)

func is_deep(unit: Variant) -> bool: return unit is Array # not empty() and last is Array and not  - PUT before

func store_keys(code: int) -> Callable:
	return func():
		if is_deep(store.last):
			store_last(code)
		else:
			store_next(code)
