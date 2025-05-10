extends RefCounted

class_name PostgreClientNotify

signal close(clean: bool)

var message: BackendMessage = BackendMessage.new()

var unique_id: int = -1
var client: String:
	get: return message.client % unique_id

func check(key: String) -> String:
	return client + message.backend[key] if message.backend.has(key) else key

func fail(message: String, postfix: String = "") -> void:
	push_error(check(message) + postfix)

func warn(message: String, postfix: String = "") -> void:
	push_warning(check(message) + postfix)

func ask_for_closure(clean: bool) -> void:
	close.emit(clean)

func force_close(message: String, postfix: String = "") -> void:
	fail(message, postfix)
	ask_for_closure(false)

func end_response(response: BackendResponses, message: String, postfix: String = "") -> void:
	force_close(message, postfix)
	response.resize(0)
