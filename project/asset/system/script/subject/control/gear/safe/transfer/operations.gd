extends RefCounted

class_name BufferOperations

var startup: PackedByteArray
var byte: PackedByteArray = bytes([0])

func bytes(count: Array[int]) -> PackedByteArray:
	return PackedByteArray(count)

func startup_message(result: Array) -> void:
	var c: Dictionary = {
		"user": "user".to_ascii_buffer(),
		"one": result[1].to_utf8_buffer(),
		"db": "database".to_ascii_buffer(),
		"two": result[5].to_utf8_buffer()
		"end": bytes([0, 0])
	}
	startup = request("", c.user + byte + c.one + byte + c.db + byte + c.two + c.end)

func p(responses, message := PackedByteArray()) -> PackedByteArray:
	responses.resize(0)
	return request('p', message)

func request(type_message: String, message := PackedByteArray()) -> PackedByteArray:
	# Get the size of message.
	var buffer := StreamPeerBuffer.new()
	var message_length := _get_reversed(buffer, func(b): b.put_u32(message.size() + (4 if type_message else 8)))
	
	# If the message is not StartupMessage...
	if type_message: buffer.put_8(type_message.unicode_at(0))
	buffer.put_data(message_length)
	
	# If the message is StartupMessage...
	if type_message.is_empty(): parse_version(buffer)
	
	buffer.put_data(message)
	error_object = {}
	return buffer.data_array.slice(4)
