extends RefCounted

class_name OperationRequests

signal reset_error()

var empty: PackedByteArray = PackedByteArray()

func query(sql: String) -> PackedByteArray:
	var q = request('Q', sql.to_utf8_buffer() + BufferOperations.bytes([0]))
	print("EXECUTE QUERY [BIN]: ", q)
	return q

func x() -> PackedByteArray:
	return request('X', empty)

func p(responses: BackendResponses, message: PackedByteArray = empty) -> PackedByteArray:
	responses.resize()
	return request('p', message)

func request_base(type: String, message: PackedByteArray, feedback: Callable) -> PackedByteArray:
	var buffer: StreamPeerBuffer = StreamPeerBuffer.new()
	var length: PackedByteArray = BufferOperations.get_message_size(buffer, type, message)
	feedback.call(buffer, length)
	buffer.put_data(message)
	reset_error.emit()
	return buffer.data_array.slice(4)

func startup(message: PackedByteArray) -> PackedByteArray:
	return request_base("", message, func(buffer, length):
		buffer.put_data(length)
		PostgreProtocolVersion.parse(buffer))

func request(type: String, message: PackedByteArray = empty) -> PackedByteArray:
	return request_base(type, message, func(buffer, length):
		buffer.put_8(type.unicode_at(0))
		buffer.put_data(length))
