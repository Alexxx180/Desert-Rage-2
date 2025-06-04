extends RefCounted

class_name ResponseFragments

var responses: PackedByteArray
var message: Dictionary = { "length": 0, "cursor": 0 }

var next: int:
	get: return message.length + 1
var current: int:
	get: return responses[message.length]
var first: int:
	get: return responses[0]

func add_answer(fragment) -> void:
	responses += fragment

func set_cursor(to: int) -> void:
	message.cursor = to

func move_cursor(appendix: int) -> void:
	set_cursor(message.cursor + appendix)

func slice(start: int = -1, end: int = -1):
	return responses.slice(start, end)

func word(start: int = message.cursor):
	var n: int = next
	return responses.slice(start, n)

static func split_byte(pool: PackedByteArray, delimiter: int) -> Array:
	var split: Dictionary = { "result": [], "from": 0, "to": 0 }
	for number in pool:
		if number == delimiter:
			var byte = pool.slice(split.from, split.to)
			split.result.append(byte)
			split.from = split.to + 1
		split.to += 1
	return split.result

func bytes(start: int, appendix: int = 0, delimiter: int = 0) -> Array:
	var pool: PackedByteArray = slice(start, message.length + appendix)
	return split_byte(pool, delimiter)

func skip_word(start: int) -> void:
	responses = responses.slice(start)
