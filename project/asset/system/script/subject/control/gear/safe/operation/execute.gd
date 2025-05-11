extends RefCounted

class_name ExecutePostgreRequest

var backend: Dictionary

func determine(result: PackedByteArray) -> void:
	backend.connection.peers.by_connection().put_data(result)

func process(response: Array) -> Array:
	if response[PollResponse.STATUS] != OK:
		backend.connection.note.warn("no_data")
		return backend.responser.DEFAULT
	return backend.responser.parse(response[PollResponse.VALUE])

func poll() -> Array:
	var peers: TransferPeers = backend.connection.peers
	peers.by_stream().poll()
	if peers.available(peers.PROTOCOL): # Crash avoidance (stream_peer_tls.get_available_bytes() = 0)
		return process(peers.get_response(peers.PROTOCOL))
	return backend.responser.DEFAULT

func query(sql: String) -> Variant: ## Send query to run the backend. "sql" contains 1+ valid SQL statements.
	var stop: bool = not backend.connection.already_had()
	if stop: backend.connection.note.fail("no_connection")
	if stop or backend.connection.busy: return backend.responser.DEFAULT # alpha # #return ERR_CONNECTION_ERROR / ERR_BUSY

	var request: PackedByteArray = backend.op.query(sql)
	determine(request)
	backend.connection.busy = true
	determine(request)

	var result: Array = backend.responser.DEFAULT
	var peers: TransferPeers = backend.connection.peers
	while backend.connection.active() and result == backend.responser.DEFAULT:
		result = poll() if peers.connected() else process(peers.get_response())

	return result # OK
