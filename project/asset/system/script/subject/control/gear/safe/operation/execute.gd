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
	var s: StreamPeerTLS = peers.stream.by()
	print("STREAM STATUS: ", s.get_status())
	#s.connect_to_host("postgres", 5432)
	#s.connect_to_stream(peers.stream.peer, "postgres")
	# s.poll()
	if peers.available(protocol): # Crash avoidance (stream_peer_tls.get_available_bytes() = 0)
		process(peers.get_response(protocol))
	
	"""
	backend.connection.status.succeed()
	var active: bool = backend.connection.active()
	if not active:
		backend.connection.note.fail("no_connection")
		return backend.responser.DEFAULT
	elif backend.connection.meta.state.busy:
		return backend.responser.DEFAULT
	
	var request: PackedByteArray = backend.op.query(sql)
	backend.connection.peers.stream.by("connection").put_data(request)
	backend.connection.meta.state.busy = true

	var result: Array = backend.responser.DEFAULT
	var peers: TransferPeers = backend.connection.peers
	while backend.connection.active() and result == backend.responser.DEFAULT:
		result = poll() if peers.connected() else process(peers.get_response())

	return result
	"""

func _execute(sql: String) -> int:
	var result: PackedByteArray = backend.op.requests.query(sql)
	print("RESULT: ", result)
	var peers: TransferPeers = backend.connection.peers
	if peers.connected():
		peers.stream.by("connection").put_data(result)
	else:
		peers.stream.peer.put_data(result)
	backend.connection.meta.state.busy = true
	get_data()
	return OK

func query(sql: String) -> Variant: ## Send query to run the backend. "sql" contains 1+ valid SQL statements.
	var active: bool = backend.connection.active()
	if active:
		return ERR_BUSY if backend.connection.meta.state.busy else _execute(sql)

	backend.connection.note.fail("no_connection")
	return ERR_CONNECTION_ERROR
