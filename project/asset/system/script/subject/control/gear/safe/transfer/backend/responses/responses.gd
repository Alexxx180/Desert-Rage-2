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

func ireverse(start: int, seek: int) -> StreamPeerBuffer:
	return buffer.put_seek(seek, reverse_data(fragments.slice(start, start + seek)))

func reverse(seek: int, start: int = -1, end: int = -1):
	return buffer.put_seek(seek, reverse_data(fragments.slice(start, end)))

func next_fragment() -> void: # There may be several messages - read first,
	var next: int = fragments.next # delete from buffer to read next in the loop.
	if fragments.responses.size() != next:
		fragments.skip_word(next)
	else:
		resize(0)
