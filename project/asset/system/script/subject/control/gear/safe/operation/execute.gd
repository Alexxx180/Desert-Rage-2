extends RefCounted

class_name ExecutePostgreRequest

var backend: Dictionary
var data: Array

func process(response: Array) -> void:
	if response[PollResponse.STATUS] != OK:
		backend.connection.note.warn("no_data")
	data = backend.responser.parse(response[PollResponse.VALUE])

func get_data() -> void:
	data = backend.responser.DEFAULT
	var peers: TransferPeers = backend.connection.peers
	var protocol: String = peers.stream.PROTOCOL
	if peers.available(protocol): # Crash avoidance (stream_peer_tls.get_available_bytes() = 0)
		process(peers.get_response(protocol))

func _execute(sql: String) -> int:
	var result: PackedByteArray = backend.op.requests.query(sql)
	var peers: TransferPeers = backend.connection.peers
	if peers.connected():
		peers.stream.by("connection").put_data(result)
	else:
		peers.stream.peer.put_data(result)
	backend.connection.meta.state.busy = true
	return OK

func query(sql: String) -> Variant: ## Send query to run the backend. "sql" contains 1+ valid SQL statements.
	var active: bool = backend.connection.active()
	if not active:
		backend.connection.note.fail("no_connection")
		return ERR_CONNECTION_ERROR
	
	if backend.connection.meta.state.busy:
		return ERR_BUSY
	
	return _execute(sql)
