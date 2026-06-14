class_name Bit

enum { MASK = 2, MASK2 = 3, MASK3 = 4, BYTE = 8, SHORT = 16, INTEGER = 32, BIG = 64 }

static func bit(no: int) -> int: return 1 << no
static func one(n: int) -> bool: return n > 0 and (n & (n - 1)) == 0

static func of(value: int, index: int) -> bool:
	var state: int = bit(index)
	return value & state == state

static func to(value: int, index: int, next: bool) -> int:
	var state: int = bit(index)
	return value & ~state | (state * int(next))

static func to1(value: int, index: int) -> int: return value | bit(index)
static func to0(value: int, index: int) -> int: return value & ~bit(index)
static func to_(value: int, index: int) -> int: return value ^ bit(index)

static func of_x(mask: int, field: int, no: int) -> int:
	return (field >> (mask * no)) & (mask - 1)

static func to_x(mask: int, field: int, no: int, next: int) -> int:
	return field & ~((mask - 1) << (mask * no)) | (next << (mask * no))

static func edit_x(mask: int, field: int, no: int, add: int) -> int:
	return to_x(mask, field, no, of_x(mask, field, no) + add)
