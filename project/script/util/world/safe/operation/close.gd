extends RefCounted

class_name CloseConnection

var backend: Dictionary

func ssl_deconnection(clean: bool) -> void:
	var stream: PeerStreams = backend.connection.peers.stream
	var protocol = stream.by("protocol", stream.PROTOCOL)
	if clean: protocol.put_data(backend.op.requests.x())
	protocol.disconnect_from_stream()

func client_disconnect(clean: bool) -> void:
	if clean: backend.connection.peers.stream.peer.put_data(backend.op.requests.x())
	backend.connection.client.disconnect_from_host()

func determine_disconnect(clean: bool) -> void:
	if backend.connection.peers.handshakes():
		ssl_deconnection(clean)
	else:
		client_disconnect(clean)

func reset_connection() -> void:
	backend.connection.reset()
	backend.connection.meta.not_busy()
	backend.connection.client.reset()
	backend.connection.note.ask_for_closure(true)

func end_dialog(clean) -> void:
	determine_disconnect(clean)
	reset_connection()

func the_connection(clean: bool = true) -> void: ## If "clean" - notify to close connection, recommended option
	if backend.connection.status.present():
		end_dialog(clean)
	else:
		backend.connection.note.warn("no_connection")
