class_name Bit

enum { MASK = 2, MASK2 = 3, INTEGER = 32, BIG = 64 }

static func bit(no: int) -> int: return 2 ** no

static func from(value: int, state: int) -> bool:
	return value & state == state

static func of(value: int, index: int) -> bool:
	var state: int = bit(index)
	return from(value, state)

static func to(value: int, index: int, next: bool) -> int:
	var state: int = bit(index)
	return value & ~state | (state * int(next)) 

static func turn(value: int, index: int) -> int:
	var state: int = bit(index)
	return value & ~state | (state * int(from(value, state)))

static func zeros(a: int, no: int) -> int: return a << no
static func whole(a: int, no: int) -> int: return a >> no
static func digit(no: int) -> int: return no * MASK

static func mask_range(no: int, mask: int) -> Array: return range(digit(no), digit(no) + mask)

static func in_mask(no: int, mask: PackedByteArray = Def.BYTE) -> Array:
	if mask != Def.BYTE and no in mask: return mask_range(no, MASK2)
	return mask_range(no, MASK)

static func masked_value(field: int, no: int, mask: PackedByteArray = Def.BYTE) -> int:
	var value: int = 0 ; for i in in_mask(no, mask): value += field & Bit.bit(i)
	return value

static func masked_digit(no: int, mask: PackedByteArray = Def.BYTE) -> int:
	var value: int = 0 ; for i in in_mask(no, mask): value += Bit.bit(i)
	return value

static func of_field(field: int, no: int, mask: PackedByteArray = Def.BYTE) -> int:
	return whole(masked_value(field, no, mask), digit(no))

static func to_field(field: int, no: int, next: int, mask: PackedByteArray = Def.BYTE) -> int:
	return field & ~masked_digit(no, mask) | zeros(next, digit(no))
