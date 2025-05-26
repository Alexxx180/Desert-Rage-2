extends RefCounted

class_name CloseConnection

var backend: Dictionary

func ssl_deconnection(clean: bool) -> void:
	var stream = backend.connection.peers.by_stream()
	if clean: stream.put_data(backend.op.x())
	stream.disconnect_from_stream()

func client_disconnect(clean: bool) -> void:
	if clean: backend.connection.peers.peer.put_data(backend.op.x())
	backend.connection.client.disconnect_from_host()

func determine_disconnect(clean: bool) -> void:
	if backend.connection.peers.handshakes():
		ssl_deconnection(clean)
	else:
		client_disconnect(clean)

func reset_connection() -> void:
	backend.connection.reset()
	backend.connection.not_busy()
	backend.connection.note.ask_for_closure(true)

func end_dialog(clean) -> void:
	determine_disconnect(clean)
	reset_connection()

func the_connection(clean: bool = true) -> void: ## If "clean", notify backend to close connection. Otherwise don't, which isn't recommended.
	if backend.connection.status.present(): end_dialog(clean)
	else: backend.connection.note.warn("no_connection")
