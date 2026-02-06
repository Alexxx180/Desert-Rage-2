extends Node

enum { INTERFACE, OPTIONS, CARD, INVENTORY }

const MASK: int = 0x02 # 4 options max, 2 digits
var settings: int = 0

static func bit(no: int) -> int: return 2 ** no
static func zeros(a: int, no: int) -> int: return a << no
static func whole(a: int, no: int) -> int: return a >> no
static func digit(no: int) -> int: return no * MASK

func _value_behind(no: int) -> int: return settings & bit(no)

func get_mask(no: int, type: Callable = bit) -> int:
	var value: int = 0
	var from: int = digit(no)
	for i in range(from, from + MASK):
		value += type.call(i)
	return value # print(" - bits: ", value)

func _get_exact_value(no: int) -> int: return get_mask(no, _value_behind)

func get_value(no: int) -> int:
	return whole(_get_exact_value(no), digit(no)) # whole(, no) # 100 # 10000 # 1000000 # 100000000

func set_value(no: int, next: int) -> void:
	settings = settings & ~get_mask(no) | zeros(next, digit(no))
