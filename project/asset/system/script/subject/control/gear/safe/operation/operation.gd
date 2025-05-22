extends RefCounted

class_name PostgresClientOperation

var poll: PollConnection = PollConnection.new()
var close: CloseConnection = CloseConnection.new()
var connection: PostgresHostConnect = PostgresHostConnect.new()
var execute: ExecutePostgreRequest = ExecutePostgreRequest.new()

func _init() -> void:
	var backend: Dictionary = {
		"connection": ConnectionMetadata.new(),
		"responses": BackendResponses.new(),
		"op": BufferOperations.new(),
		"credit": EncryptionCredentials.new(),
		"responser": ResponseParser.new()
	}
	connection.change_security.connect(poll.rollback.change_security)
	backend.responser.object = backend
	backend.connection.note.end.connect(backend.responses.resize)
	for operation in [poll, close, connection, execute]:
		operation.backend = backend
