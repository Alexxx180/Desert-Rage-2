class_name Bit

enum { MASK = 2, MASK2 = 3, BYTE = 8, INTEGER = 32, BIG = 64 }

static func bit(no: int) -> int: return 1 << no

static func empty(n: int) -> bool: return n == 0

static func single(n: int) -> bool: return n > 0 and (n & (n - 1)) == 0

static func from(value: int, state: int) -> bool:
	return value & state == state

static func of(value: int, index: int) -> bool:
	return from(value, bit(index))

static func to(value: int, index: int, next: bool) -> int:
	var state: int = bit(index)
	return value & ~state | (state * int(next)) 

static func turn(value: int, index: int) -> int:
	var state: int = bit(index)
	return value & ~state | (state * int(from(value, state)))

static func index8(index: int) -> Vector2i: return indexes(BYTE, index)
static func index32(index: int) -> Vector2i: return indexes(INTEGER, index)
static func indexes(digits: int, index: int) -> Vector2i:
	var cursor: Vector2i = Vector2i(0, index)
	while cursor.y > digits: cursor = Vector2i(cursor.x + 1, cursor.y - digits)
	return cursor

static func digit(no: int) -> int: return no * MASK

static func mask_range(no: int, mask: int) -> Array: return range(digit(no), digit(no) + mask)

static func in_mask(no: int, mask: PackedByteArray = Def.BYTE) -> Array:
	if mask != Def.BYTE and no in mask: return mask_range(no, MASK2)
	return mask_range(no, MASK)

static func masked_value(field: int, no: int, mask: PackedByteArray = Def.BYTE) -> int:
	var value: int = 0 ; for i in in_mask(no, mask): value |= field & Bit.bit(i)
	return value

static func masked_digit(no: int, mask: PackedByteArray = Def.BYTE) -> int:
	var value: int = 0 ; for i in in_mask(no, mask): value |= Bit.bit(i)
	return value

static func of_field(field: int, no: int, mask: PackedByteArray = Def.BYTE) -> int:
	return masked_value(field, no, mask) >> digit(no)

static func to_field(field: int, no: int, next: int, mask: PackedByteArray = Def.BYTE) -> int:
	return field & ~masked_digit(no, mask) | (next << digit(no))
