extends RefCounted

class_name BufferOperations

const STARTUP: String = ""

var startup: PackedByteArray
var byte: PackedByteArray = bytes([0])
var empty: PackedByteArray = PackedByteArray()

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
	startup = request(STARTUP, c.user + byte + c.one + byte + c.db + byte + c.two + c.end)

func _get_reversed(buffer: StreamPeerBuffer, value: int, method: Callable) -> PackedByteArray:
	method.call(buffer, value)
	var bytes: PackedByteArray = buffer.data_array
	bytes.reverse()
	return bytes

func put_u32(buffer: StreamPeerBuffer, value: int) -> void: buffer.put_u32(value)
func put_32(buffer: StreamPeerBuffer, value: int) -> void: buffer.put_32(value)
func reverse(value: int, method: Callable) -> void:
	return _get_reversed(StreamPeerBuffer.new(), value, method)

func query(sql: String) -> PackedByteArray: return request('Q', sql.to_utf8_buffer() + byte)
func x() -> PackedByteArray: return request('X', PackedByteArray())

func p(responses, message := PackedByteArray()) -> PackedByteArray:
	responses.resize(0)
	return request('p', message)

func get_message_size(type: String, message: PackedByteArray) -> PackedByteArray:
	return _get_reversed(buffer, message.size() + (4 if type else 8), put_u32)

func request(type: String, message: PackedByteArray = empty) -> PackedByteArray:
	var buffer: StreamPeerBuffer = StreamPeerBuffer.new()
	var length: PackedByteArray = get_message_size(type, message)
	
	if type != STARTUP: buffer.put_8(type.unicode_at(0))
	buffer.put_data(length)
	if type == STARTUP: parse_version(buffer)
	
	buffer.put_data(message)
	error_object = {}
	return buffer.data_array.slice(4)
