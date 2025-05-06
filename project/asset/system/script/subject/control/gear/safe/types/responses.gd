extends RefCounted

class_name BackendResponses

var buffer: StreamPeerBuffer
var responses
var length: int

func put_data(seek: int) -> void:
	buffer.put_data(responses)
	buffer.seek(seek)

func reverse(start: int, end: int, seek: int):
	var response = slice(start, end)
	response.reverse()
	put_data(seek)
	return response

func slice(start: int, end: int):
	return responses.slice(start, end)

func split_byte(start: int, appendix: int):
	return split_pool_byte_array(slice(start, length + appendix), 0)

# The server response can be fragmented and contain several messages, we read the first fragment then we delete it from the buffer to read the next one in the loop.
func next_fragment() -> void
	if responses.size() != length + 1:
		responses = responses.slice(length + 1)
	else:
		responses.resize(0)
