extends RefCounted

class_name BackendResponses

var buffer: StreamPeerBuffer
#var _responses: PackedByteArray
var responses: PackedByteArray#: #var length: int #var cursor: int
#	get: return _responses
#	set(value): _responses = value
var message: Dictionary = { "length": 0, "cursor": 0 } #, "start": 0, "end": 0 }
var result: PostgreSQLQueryResult = PostgreSQLQueryResult.new()

func put_data(seek: int) -> void:
	buffer.put_data(responses)
	buffer.seek(seek)

func add_answer(fragment) -> void:
	responses += fragment

func get_first() -> int: return responses[0]
func get_current() -> int: return responses[message.length]
func resize(next: int = 0) -> void: responses.resize(next)
#func _range(start: int, end: int) -> void:
#	message.end = end; message.start = start
"""
func _appendix(basis: int, a: int = -1, b: int = -1) -> void:
	if b == -1: 
		_range(message.cursor, basis + a)
		if basis == message.cursor: message.cursor = b
	else: _range(a, b)
"""

static func reverse_data(data) -> PackedByteArray:
	data.reverse()
	return data

func _put_seek(seek: int) -> StreamPeerBuffer:
	put_data(seek)
	return buffer

func ireverse(start: int, seek: int) -> StreamPeerBuffer:
	reverse_data(responses.slice(start, start + seek))
	return _put_seek(seek)

func reverse(seek: int, start: int = -1, end: int = -1):
	reverse_data(responses.slice(start, end))
	return _put_seek(seek)

func enough() -> bool: return 4 < responses.size()
func has_words() -> bool: return responses.size() < message.length + 1

func islice(start: int = -1):
	var cursor: int = message.cursor
	if cursor == message.length: message.cursor = -1
	return responses.slice(cursor, cursor + start)

func slice(start: int = -1, end: int = -1):
	return responses.slice(start, end)

func slice_word(start: int): return responses.slice(start, message.length + 1)

func split_byte(start: int, appendix: int, delimiter: int = 0) -> Array:
	var pool: PackedByteArray = slice(start, message.length + appendix)
	var split: Dictionary = { "result": [], "from": 0, "to": 0 }
	for byte in pool:
		if byte == delimiter:
			split.result.append(slice(split.from, split.to + 1))
			split.from = split.to + 1
		split.to += 1
	return split.result

func next_fragment() -> void: # There may be several messages - read first,
	var next: int = message.length + 1 # delete from buffer to read next in the loop.
	if responses.size() == next: resize(0)
	else: responses = responses.slice(next)
