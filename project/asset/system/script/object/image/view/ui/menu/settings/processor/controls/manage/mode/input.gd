extends Node

signal finish_combo(keys: Array[String])
signal enter_keys(keys: Array[String])

var next: Array = []
var group: int = 0
var locked: bool = false
var key_mask: int = 1
var mode: Node
var last: Variant:
	get: return next.back()

enum { RESET = 0, SINGLE = 1, MAX = 3 }

func next_key(state: bool, digit: int, op: Callable) -> void:
	if state:
		op.call()
		group = digit

func reset() -> void: group = RESET
func nullify() -> void: next[RESET] = Defaults.INT

func group_key(code: int) -> Callable:
	return func():
		if next.back() is Array:
			last[group] = code
			enter()
		else:
			next[group] = code

func start_enter() -> void: next_key(agg_defined(), RESET, func(): form(key_mask))
func enter_next(code: int) -> void: next_key(agg_undefined(), group + 1, group_key(code))
func present(code: int, deep: bool = false) -> bool: return code in (last if deep else next)

func agg_defined() -> bool: return not agg_undefined()
func agg_undefined() -> bool: return Defaults.INT in last
func key_defined() -> bool: return last == Defaults.INT

func clear() -> void: next.clear() ; reset()
func update() -> void: reset() ; enter()

func remove_last() -> void:
	if next.size() > 1: next.pop_back()
	last.clear() ; update()
	locked = false

func delete_last() -> void:
	next.pop_back()
	clear_last() ; update()

func clear_last() -> void:
	if key_mask == SINGLE:
		if last is int:
			if next.size() > 0:
				next.pop_back()
			#else:
			#	nullify()
		else:
			last.clear()
	else:
		last.fill(Defaults.INT)
		update()

func add_key(code: int, max: int = MAX) -> void:
	append(code)
	if compare(max): finish()
	else: enter()

func append(unit: Variant) -> void:
	if not empty() and last is Array and not unit is Array:
		last.push_back(unit)
	else:
		next.push_back(unit)

func compare(to: int) -> bool: return next.size() == to
func empty() -> bool: return compare(0)
func limit() -> bool: return compare(MAX)

func add() -> void: append([])
func form(count: int) -> void:
	var unit: Array = []
	unit.resize(count)
	unit.fill(Defaults.INT)
	append(unit)

func enter(sig: Signal = enter_keys) -> void: sig.emit(mode.translate(next))

func finish() -> void: enter(finish_combo) ; clear() ; mode.type.clear()

func mask(keys: int, type: Node) -> void:
	key_mask = keys
	match type.selected:
		type.AGG: form(keys) # if keys != SINGLE
		type.ALL: add()
	enter()
