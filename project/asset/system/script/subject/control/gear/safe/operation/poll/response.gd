extends RefCounted

class_name PollResponse

enum { STATUS = 0, VALUE = 1, SSL = 3 }

var backend: Dictionary

func poll() -> bool:
	backend.connection.client.poll()
	var connected: bool = backend.connection.client.connected()
	if connected: backend.connection.peers.poll()
	return connected

func check() -> void:
	if not backend.connection.ssl_ready(): return

	var storage: Variant = backend.connection.ssl_peers()
	var response: Array = backend.connection.peers.get_from(storage)
	var text: PackedByteArray = response[VALUE]

	if response[STATUS] == OK and text.size():
		var service: Variant = backend.responser.parse(text)
		if service: storage.put_data(service)

func start() -> void:
	var present: bool = backend.connection.present()
	var busy: bool = backend.connection.state.busy
	if not (present and busy): return

	var peers: TransferPeers = backend.connection.peers
	var response: Array = [OK, backend.op.empty]
	if peers.connected() and peers.available(peers.PROTOCOL):
		response = peers.get_response(peers.PROTOCOL)
	else: # Crash avoidance (stream_peer_tls.get_available_bytes() = 0)
		response = peers.get_response()
	
	if response[STATUS] != OK: backend.connection.note.warn("no_data")
	else: backend.responser.parse(response[VALUE])

func set_data() -> void:
	if backend.connection.startup_ready():
		backend.connection.peers.put_data(backend.op.startup)
		backend.connection.state.ssl = SSL
