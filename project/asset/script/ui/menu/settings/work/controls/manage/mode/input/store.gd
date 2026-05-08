extends Node

var next: Array = []
var last: Variant:
	get: return next.back()
var agg: int:
	get: return next.size() - 1

enum { RESET = 0, SINGLE = 1, MAX = 3 } # SINGLE = 1, # const RESET: int = 0

func hardcoded() -> Array: # prevents users from binding keys
	return [KEY_ESCAPE, KEY_ENTER, KEY_BACKSPACE, KEY_COMMA, KEY_0, KEY_1, KEY_2,
		KEY_3, KEY_4, KEY_5, KEY_6, KEY_7, KEY_8, KEY_9]

func nullify_agg() -> void: last.fill(Def.INT)
func nullify() -> void: sets(next, RESET, Def.INT)
func sets(element: Array, no: int, code: int) -> void: element[no] = code

func present(code: int, deep: bool = false) -> bool: return code in (last if deep else next)
func defined() -> bool: return not undefined()
func undefined() -> bool: return Def.INT in last
func is_mask() -> bool: return last == Def.INT

func remove() -> void: next.pop_back()
func clear() -> void: next.clear()
func shorten() -> void: last.clear()

func add_last(unit: Variant) -> void: last.push_back(unit)
func add_next(unit: Variant) -> void:
	next.push_back(unit)
	agg = next.size() - 1

func compare(to: int) -> bool: return next.size() == to
func empty() -> bool: return compare(RESET)
func limit() -> bool: return compare(MAX)
func masked() -> bool: return next.size() > SINGLE

func is_hard(code: bool) -> bool: return code in hardcoded()
func key_hold(code: int) -> bool: return not is_hard(code) or not empty()
func key_alt(_code: int) -> bool: return not limit()
func key_press(code: int) -> bool: return key_hold(code) and key_alt(code)

func unique(e: InputEvent, deep: bool = false) -> bool:
	return e.is_pressed() and not present(e.keycode, deep)

func append(unit: Variant, mode: Node) -> void:
	if mode.input.link.is_deep(unit): # and not empty():
		add_next(unit)
	elif mode.type.deep():
		add_last(unit)
	else:
		add_next(unit)
