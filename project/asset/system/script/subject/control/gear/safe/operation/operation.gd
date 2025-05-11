extends RefCounted

class_name PostgresClientOperation

var poll: PollConnection = PollConnection.new()
var close: CloseConnection = CloseConnection.new()
var connect: PostgresHostConnect = PostgresHostConnect.new()
var execute: ExecutePostgreRequest = ExecutePostgreRequest.new()

func _init() -> void:
	var backend: Dictionary = {
		"connection": ConnectionMetadata.new(),
		"responses": BackendResponses.new(),
		"op": BufferOperations.new(),
		"credit": EncryptionCredentials.new()
		"responser": ResponseParser.new()
	}
	backend.responser.object = backend
	backend.connection.note.end.connect(backend.responses.resize)
	for operation in [poll, close, connect, execute]:
		operation.backend = backend
