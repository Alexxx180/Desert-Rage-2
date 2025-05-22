extends RefCounted

class_name PostgreClientNotify

signal close(clean: bool)
signal end()

var message: BackendMessage = BackendMessage.new()

var unique_id: int = -1
var client: String:
	get: return message.client % unique_id

func check(key: String) -> String:
	return client + " " + message.backend[key] if message.backend.has(key) else key

func fail(text: String, postfix: String = "") -> void:
	push_error(check(text) + postfix)

func warn(text: String, postfix: String = "") -> void:
	push_warning(check(text) + postfix)

func ask_for_closure(clean: bool) -> void:
	close.emit(clean)

func force_close(text: String, postfix: String = "") -> void:
	fail(text, postfix)
	ask_for_closure(false)

func end_response(text: String, postfix: String = "") -> void:
	force_close(text, postfix)
	end.emit()
