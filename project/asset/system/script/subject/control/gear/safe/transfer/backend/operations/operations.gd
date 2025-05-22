extends RefCounted

class_name BufferOperations

signal reset_error()

var startup: PackedByteArray
var byte: PackedByteArray = bytes([0])
var empty: PackedByteArray = PackedByteArray()

func bytes(count: Array[int]) -> PackedByteArray:
	return PackedByteArray(count)

func startup_message(user: String, db: String) -> void:
	var c: Dictionary = {
		"user": "user".to_ascii_buffer() + byte + user.to_utf8_buffer(),
		"db": "database".to_ascii_buffer() + byte + db.to_utf8_buffer(),
		"end": bytes([0, 0])
	}
	startup = request_startup(c.user + byte + c.db + c.end)

func _get_reversed(buffer: StreamPeerBuffer, value: int, method: Callable) -> PackedByteArray:
	method.call(buffer, value)
	var data: PackedByteArray = buffer.data_array
	data.reverse()
	return data

func put_u32(buffer: StreamPeerBuffer, value: int) -> void: buffer.put_u32(value)
func put_32(buffer: StreamPeerBuffer, value: int) -> void: buffer.put_32(value)
func reverse(value: int, method: Callable) -> PackedByteArray:
	return _get_reversed(StreamPeerBuffer.new(), value, method)

func query(sql: String) -> PackedByteArray: return request('Q', sql.to_utf8_buffer() + byte)
func x() -> PackedByteArray: return request('X', empty)
func p(responses: BackendResponses, message: PackedByteArray = empty) -> PackedByteArray:
	responses.resize()
	return request('p', message)

func get_message_size(buffer: StreamPeerBuffer, type: String, message: PackedByteArray) -> PackedByteArray:
	return _get_reversed(buffer, message.size() + (4 if type else 8), put_u32)

func request_base(type: String, message: PackedByteArray, feedback: Callable) -> PackedByteArray:
	var buffer: StreamPeerBuffer = StreamPeerBuffer.new()
	var length: PackedByteArray = get_message_size(buffer, type, message)
	feedback.call(buffer, length)
	buffer.put_data(message)
	reset_error.emit()
	return buffer.data_array.slice(4)

func request_startup(message: PackedByteArray) -> PackedByteArray:
	return request_base("", message, func(buffer, length):
		buffer.put_data(length)
		PostgreProtocolVersion.parse(buffer, self))

func request(type: String, message: PackedByteArray = empty) -> PackedByteArray:
	return request_base(type, message, func(buffer, length):
		buffer.put_8(type.unicode_at(0))
		buffer.put_data(length))
