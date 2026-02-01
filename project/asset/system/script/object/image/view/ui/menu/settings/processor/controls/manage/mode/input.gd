extends Node

signal finish_combo(keys: Array[String])
signal enter_keys(keys: Array[String])

var next: Array = []
var group: int = 0
var key_mask: int = 1
var mode: Node

enum { RESET = 0, SINGLE = 1, MAX = 3 }

func next_key(state: bool, digit: int, op: Callable) -> void:
	if state:
		op.call()
		group = digit

func group_key(code: int) -> Callable:
	return func():
		if next.front() is Array:
			next.back()[group] = code
			enter(next)
		else:
			next[group] = code

func start_enter() -> void: next_key(agg_defined(), RESET, func(): form(key_mask))
func enter_next(code: int) -> void: next_key(agg_undefined(), group + 1, group_key(code))

func present(code: int, deep: bool = false) -> bool:
	return code in (next.front() if deep else next)

func agg_defined() -> bool: return not agg_undefined()
func agg_undefined() -> bool: return Defaults.INT in next.front()
func key_defined() -> bool: return next.front() == Defaults.INT

func clear() -> void:
	next.clear()
	group = RESET

func append(unit: Variant) -> void: next.push_back(unit)
func empty() -> bool: return next.size() == 0
func limit() -> bool: return next.size() >= MAX

func form(count: int) -> void:
	var unit: Array = []
	unit.resize(count)
	unit.fill(Defaults.INT)
	append(unit)

func enter(sequence: Array = next) -> void:
	enter_keys.emit(mode.translate(sequence))

func finish(sequence: Array = next) -> void:
	finish_combo.emit(mode.translate(sequence))
	clear()
	mode.type.clear()

func mask(keys: int) -> void:
	key_mask = keys
	if keys != SINGLE: form(keys)
	enter()
