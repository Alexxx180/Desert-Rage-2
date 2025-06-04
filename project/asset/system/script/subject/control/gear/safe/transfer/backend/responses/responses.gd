extends RefCounted

class_name BackendResponses

var fragments: ResponseFragments = ResponseFragments.new()
var buffer: ResponsesBuffer = ResponsesBuffer.new()

var enough: bool:
	get: return 4 < fragments.responses.size()
var fragmented: bool:
	get: return fragments.responses.size() < fragments.next

func resize(next: int = 0) -> void:
	fragments.responses.resize(next)

static func reverse_data(data: PackedByteArray) -> PackedByteArray:
	data.reverse()
	return data

func reverse(seek: int, start: int = -1, end: int = -1):
	return buffer.put_seek(seek, reverse_data(fragments.slice(start, end)))

func cursor_reverse(appendix: int, seek: int) -> StreamPeerBuffer:
	var cursor: int = fragments.message.cursor
	var next: int = cursor + appendix
	var data: PackedByteArray = fragments.slice(cursor, next)
	fragments.set_cursor(next)
	return buffer.put_seek(seek, reverse_data(data))

func next_fragment() -> void: # There may be several messages - read first,
	var next: int = fragments.next # delete from buffer to read next in the loop.
	if fragments.responses.size() != next:
		fragments.skip_word(next)
	else:
		resize(0)
