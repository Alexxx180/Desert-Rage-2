extends RefCounted

class_name BufferOperations

var startup: PackedByteArray
var requests: OperationRequests = OperationRequests.new()
var byte: PackedByteArray = bytes([0])
var empty: PackedByteArray:
	get: return PackedByteArray()

static func bytes(count: Array[int]) -> PackedByteArray:
	return PackedByteArray(count)

func reset_startup() -> void: startup = empty

func startup_message(user: String, db: String) -> void:
	var c: Dictionary = {
		"user": "user".to_ascii_buffer() + byte + user.to_utf8_buffer(),
		"db": "database".to_ascii_buffer() + byte + db.to_utf8_buffer(),
		"end": bytes([0, 0])
	}
	startup = requests.startup(c.user + byte + c.db + c.end)
	print("STARTUP MESSAGE: ", startup)

func reverse(value: int, method: Callable) -> PackedByteArray:
	return _get_reversed(StreamPeerBuffer.new(), value, method)

static func _get_reversed(buffer: StreamPeerBuffer, value: int, method: Callable) -> PackedByteArray:
	method.call(buffer, value)
	return Transfer.reverse(buffer.data_array)

static func put_u32(buffer: StreamPeerBuffer, value: int) -> void: buffer.put_u32(value)
static func put_32(buffer: StreamPeerBuffer, value: int) -> void: buffer.put_32(value)

static func get_message_size(buffer: StreamPeerBuffer, type: String, message: PackedByteArray) -> PackedByteArray:
	return _get_reversed(buffer, message.size() + (4 if type else 8), put_u32)
