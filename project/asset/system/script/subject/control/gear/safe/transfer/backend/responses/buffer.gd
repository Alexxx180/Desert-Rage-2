extends RefCounted

class_name ResponsesBuffer

enum { LENGTH = 0, AUTH = 4 }

var result: PostgreSQLQueryResult = PostgreSQLQueryResult.new()
var stream: StreamPeerBuffer = StreamPeerBuffer.new()

func renew() -> void:
	stream = StreamPeerBuffer.new()

func put_data(seek: int, responses: PackedByteArray) -> void:
	stream.put_data(responses)
	stream.seek(seek)

func put_seek(seek: int, responses: PackedByteArray) -> StreamPeerBuffer:
	put_data(seek, responses)
	return stream
