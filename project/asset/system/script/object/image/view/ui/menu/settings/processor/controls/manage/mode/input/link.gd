extends Node

signal finish_combo(keys: Array[String])
signal enter_keys(keys: Array[String])

var group: int = 0
var mode: Node

func reset() -> void: group = 0
func next() -> int: return group + 1
func clear() -> void: mode.type.clear()

func form(count: int) -> Array:
	var unit: Array = []
	unit.resize(count)
	unit.fill(Defaults.INT)
	return unit

func set_position(place: int) -> void: group = place

func store_code(store: Node, element: Array, code: int) -> void:
	store.sets(element, group, code)

func store_next(store: Node, code: int) -> void:
	store.sets(store, store.next, code)

func store_last(store: Node, code: int) -> void:
	store_code(store, store.last, code)
	enter(store.next)

func enter(codes: Array, input: Signal = enter_keys) -> void:
	input.emit(mode.translate(codes))

func finish(codes: Array) -> void: enter(codes, finish_combo)

func is_shallow(unit: Variant) -> bool: return unit is Array # not empty() and last is Array and not  - PUT before

func store_keys(store: Node, code: int) -> Callable:
	return func():
		if is_shallow(store.last):
			store_last(store, code)
		else:
			store_next(store, code)
