extends RefCounted

class_name PollResponse

enum { STATUS = 0, VALUE = 1, SSL = 3 }

var connection: ConnectionMetadata
var responser: ResponseParser
var op: BufferOperations

func poll() -> bool:
	var status: bool = connection.poll()
	if not status: connection.peers.poll()
	return status

func check() -> void:
	if not connection.ssl_ready(): return

	var storage: Variant = connection.ssl_peers()
	var response: Array = connection.peers.get_from(storage)
	var text: PackedByteArray = response[VALUE]

	if response[STATUS] == OK and text.size():
		var service: Variant = responser.parse(text)
		if service: storage.put_data(service)

func start() -> void:
	if not (connection.present() and connection.state.busy): return

	var response: Array = [OK, op.empty]
	if connection.peers.connected() and connection.peers.available(peers.PROTOCOL):
		response = connection.peers.get_response(peers.PROTOCOL)
	else: # Crash avoidance (stream_peer_tls.get_available_bytes() = 0)
		response = connection.peers.get_response()
	
	if response[STATUS] != OK: connection.note.warn("no_data")
	else: responser.parse(response[VALUE])

func set_data() -> void:
	if connection.startup_ready():
		connection.peers.put_data(op.startup)
		connection.state.ssl = SSL
