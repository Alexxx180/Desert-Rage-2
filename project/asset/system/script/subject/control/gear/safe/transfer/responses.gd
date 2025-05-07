extends RefCounted

class_name BackendResponses

var buffer: StreamPeerBuffer
var responses: PackedByteArray
var length: int
var cursor: int

func put_data(seek: int) -> void:
	buffer.put_data(responses)
	buffer.seek(seek)

func get_current() -> int:
	return responses[length]

func reverse(seek: int, start: int = -1, end: int = -1):
	if end == -1:
		end = cursor + (2 if start == -1 else start)
		start = cursor
		cursor = end
	var response = slice(start, end)
	response.reverse()
	put_data(seek)
	return buffer

func slice(start: int = -1, end: int = -1):
	if end == -1:
		end = length
		if start != -1: end += start
		start = cursor
	return responses.slice(start, end)

func split_byte(start: int, appendix: int, delimiter: int = 0) -> Array:
	var pool: PackedByteArray = slice(start, length + appendix)
	var result: Array = []
	var from: int = 0
	var to: int = 0
	
	for byte in pool:
		if byte == delimiter:
			result.append(slice(from, to + 1))
			from = to + 1
		to += 1
	return array

# Server response can be fragmented and contain several messages, we read the first then we delete it from the buffer to read the next one in the loop.
func next_fragment() -> void
	if responses.size() != length + 1:
		responses = responses.slice(length + 1)
	else:
		responses.resize(0)
