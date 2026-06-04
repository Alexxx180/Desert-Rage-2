class_name Bit

enum { MASK = 2, MASK2 = 3, MASK3 = 4, BYTE = 8, INTEGER = 32, BIG = 64 }

static func bit(no: int) -> int: return 1 << no

static func empty(n: int) -> bool: return n == 0

static func single(n: int) -> bool: return n > 0 and (n & (n - 1)) == 0

static func of(value: int, index: int) -> bool:
	var state: int = bit(index)
	return value & state == state

static func to(value: int, index: int, next: bool) -> int:
	var state: int = bit(index)
	return value & ~state | (state * int(next))

static func to1(value: int, index: int) -> int: return value | bit(index)
static func to0(value: int, index: int) -> int: return value & ~bit(index)
static func to_(value: int, index: int) -> int: return value ^ bit(index)

static func index8(index: int) -> Vector2i: return indexes(BYTE, index)
static func index32(index: int) -> Vector2i: return indexes(INTEGER, index)
static func indexes(digits: int, index: int) -> Vector2i:
	var cursor: Vector2i = Vector2i(0, index)
	while cursor.y > digits: cursor = Vector2i(cursor.x + 1, cursor.y - digits)
	return cursor

static func digit(no: int) -> int: return no * MASK

static func mask_range(no: int, mask: int) -> Array: return range(digit(no), digit(no) + mask)

static func of_num(field: int, no: int, mask: int) -> int: return (field >> (mask * no)) & mask
static func of4(field: int, no: int) -> int: return of_num(field, no, MASK)
static func of8(field: int, no: int) -> int: return of_num(field, no, MASK2)
static func of16(field: int, no: int) -> int: return of_num(field, no, MASK3)

static func add(field: int, value: int) -> int: return field << Bit.MASK2 | value

static func take8(fields: PackedByteArray) -> int: return take(fields, MASK2)
static func take(fields: PackedByteArray, mask: int) -> int:
	var result: int = 0 ; var count: int = len(fields)
	for i in count: result |= fields[i] << (mask * (count - i))
	return result

static func in_mask(no: int, mask: PackedByteArray = Def.ARRAY) -> Array:
	if mask.size() > 0 and no in mask: return mask_range(no, MASK2)
	return mask_range(no, MASK)

static func masked_value(field: int, no: int, mask: PackedByteArray = Def.ARRAY) -> int:
	var value: int = 0 ; for i in in_mask(no, mask): value |= field & Bit.bit(i)
	return value

static func masked_digit(no: int, mask: PackedByteArray = Def.ARRAY) -> int:
	var value: int = 0 ; for i in in_mask(no, mask): value |= Bit.bit(i)
	return value

static func of_field(field: int, no: int, mask: PackedByteArray = Def.ARRAY) -> int:
	return masked_value(field, no, mask) >> digit(no)

static func to_field(field: int, no: int, next: int, mask: PackedByteArray = Def.ARRAY) -> int:
	return field & ~masked_digit(no, mask) | (next << digit(no))
