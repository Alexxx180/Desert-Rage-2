extends RefCounted

class_name Works

static func turn(holder: Node, condition: bool) -> void:
	holder.process_mode = Node.PROCESS_MODE_INHERIT if condition else Node.PROCESS_MODE_DISABLED

static func bit(no: int) -> int: return 2 ** no

static func is_bit(value: int, index: int) -> bool:
	var digit: int = bit(index)
	return value & digit == digit
