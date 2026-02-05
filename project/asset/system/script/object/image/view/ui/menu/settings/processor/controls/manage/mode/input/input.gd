extends Node

@onready var store: Node = $store
@onready var link: Node = $link

var key_mask: int = 1
var locked: bool = false
var place: int:
	get: return min(get_place(store.last, Defaults.INT), key_mask - 1)
var MAX: int:
	get: return store.MAX

const SINGLE: int = 1

func get_place(s: Array, n: int) -> int: return s.size() - s.count(n)
func next_key(state: String, op: Callable) -> void:
	if store.get(state).call():
		op.call()

func start_enter() -> void: next_key("defined", add_mask)
func enter_next(code: int) -> void: next_key("undefined", link.store_keys(code))

func clear() -> void: store.clear() ; enter()
func stop_operating() -> void: store.clear(); link.clear()

func _remove_unit() -> void: if not store.masked(): store.remove()
func _remove_after_mask() -> void: if not store.empty(): store.remove()
func remove_last() -> void:
	_remove_unit() ; store.shorten() ; enter()
	locked = false

func nullify() -> void: store.nullify()
func delete_last() -> void:
	store.remove() ; clear_last() ; enter()

func agg(type: Node) -> int:
	print("GROUP PLACE: ", place)
	return place if type.aggregated_mask() else store.agg

func _remove_deep() -> void:
	if link.is_shallow(store.last):
		store.shorten()
	else:
		_remove_after_mask()

func nullify_group() -> void:
	store.nullify_agg() ; enter()

func clear_last() -> void:
	if key_mask == SINGLE:
		_remove_deep()
	else:
		nullify_group()

func lock(state: bool) -> bool:
	locked = state
	return true

func add_key(code: int, maximum: String) -> void:
	append(code) ; get("finish" if store.compare(get(maximum)) else "enter").call()

func append(unit: Variant) -> void: store.append(unit, link.mode)
func add() -> void: append([])
func add_mask() -> void: append(link.form(key_mask))

func enter() -> void: link.enter(store.next)
func finish() -> void: link.finish(store.next) ; stop_operating()
func interrupt() -> void: link.interrupt() ; stop_operating()

func hotkeys(code: int) -> bool:
	return not locked or store.is_hard(code) and lock(true)

func got_hotkey(event: InputEvent, state: bool = true) -> bool:
	return not event.is_pressed() and lock(state)

func mask(keys: int, type: Node) -> void:
	key_mask = keys
	match type.selected:
		type.AGG: add_mask() # if keys != SINGLE
		type.ALL: add()
	enter()
