extends RefCounted

class_name ExecutePostgreRequest

var op: BufferOperations
var connection: ConnectionMetadata
var responser: ResponseParser

func determine(result: PackedByteArray) -> void:
	connection.peers.by_connection().put_data(result)

func process(response: Array) -> Array:
	if response[PollResponse.STATUS] != OK:
		note.warn("no_data")
		return responser.DEFAULT
	return responser.parse(response[PollResponse.VALUE])

func poll() -> Array:
	connection.peers.by_stream().poll()
	if connection.peers.available(peers.PROTOCOL): # Crash avoidance (stream_peer_tls.get_available_bytes() = 0)
		return process(connection.peers.get_response(peers.PROTOCOL))
	return responser.DEFAULT

func execute(sql: String) -> Variant: ## Send query to run the backend. "sql" contains 1+ valid SQL statements.
	var _stop: bool = not connection.already_had()
	if _stop: note.fail("no_connection")
	if _stop or connection.busy: return responser.DEFAULT # alpha # #return ERR_CONNECTION_ERROR / ERR_BUSY

	var request: PackedByteArray = op.query(sql)
	determine(request)
	connection.busy = true
	determine(request)

	var result: Array = responser.DEFAULT
	while connection.active() and result == responser.DEFAULT:
		result = poll() if connection.peers.connected() else process(connection.peers.get_response())

	return result # OK
