extends RefCounted

class_name CloseConnection

var connection: ConnectionMetadata
var op: BufferOperations

func ssl_deconnection(clean: bool) -> void:
	var stream = connection.peers.by_stream()
	if clean: stream.put_data(op.x())
	stream.disconnect_from_stream()

func client_disconnect(clean: bool) -> void:
	if clean: connection.peers.peer.put_data(op.x())
	connection.client.disconnect_from_host()

func disconnect(clean: bool) -> void:
	if connection.peers.handshakes():
		ssl_deconnection(clean)
	else:
		client_disconnect(clean)

func reset_connection() -> void:
	connection.reset()
	connection.not_busy()
	connection.note.ask_for_closure(true)

func end_dialog(clean) -> void:
	disconnect(clean)
	reset_connection()

func close(clean: bool = true) -> void: ## If "clean", notify backend to close connection. Otherwise don't, which isn't recommended.
	if connection.present():
		end_dialog(clean)
	else:
		connection.note.warn("no_connection")
