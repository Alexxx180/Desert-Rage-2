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

static func b0(state: PackedByteArray, select: int, index: int) -> void:
	state[select] = to0(state[select], index)

static func b1(state: PackedByteArray, select: int, index: int) -> void:
	state[select] = to1(state[select], index)

static func n0(state: PackedInt64Array, select: int, index: int) -> void:
	state[select] = to0(state[select], index)

static func n1(state: PackedInt64Array, select: int, index: int) -> void:
	state[select] = to1(state[select], index)

static func i0(state: PackedInt32Array, select: int, index: int) -> void:
	state[select] = to0(state[select], index)

static func i1(state: PackedInt32Array, select: int, index: int) -> void:
	state[select] = to1(state[select], index)

static func of_x(mask: int, field: int, no: int) -> int:
	return (field >> (mask * no)) & (mask - 1)

static func to_x(mask: int, field: int, no: int, next: int) -> int:
	return field & ~((mask - 1) << (mask * no)) | (next << (mask * no))

static func edit_x(mask: int, field: int, no: int, add: int) -> int:
	return to_x(mask, field, no, of_x(mask, field, no) + add)

static func bytes_to_int(fields: PackedByteArray, mask: int) -> int:
	var value: int = 0 ; for i in range(0, len(fields)): value |= fields[i] << (i * mask)
	return value

"""
static func iterate_set_bits(mask: int) -> int: # Handle negative integers safely if treating as an unsigned bitmask
	while mask != 0:
		var bit_index: int = ctz(mask) # 1. Find the index of the lowest set bit (0 to 63)
		print("Found active bit at index: ", bit_index) # 2. Execute your logic with the active index
		mask = mask & (mask - 1) # # 3. Clear the lowest set bit to move to the next one
"""
