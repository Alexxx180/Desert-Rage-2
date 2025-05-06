extends RefCounted

class_name PostgreClientNotify

signal close(clean: bool)

var busy: bool = false

var unique_id: int
var client: String:
	get: return "[PostgreSQLClient:%d]" % unique_id

func fail(message: String) -> void:
	push_error(client + message)

func warn(message: String) -> void:
	push_warning(client + message)

func force_close(message: String) -> void:
	note.fail(message)
	close.emit(false)

func end_response(response: BackendResponses, message: String) -> void:
	force_close(message)
	response.resize(0
