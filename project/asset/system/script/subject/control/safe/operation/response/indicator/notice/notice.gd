extends RefCounted

class_name NoticeResponses # consists of 1+ fields in any order, followed by \0 terminator.

# var connection: ConnectionMetadata
var fields: NoticeFields = NoticeFields.new()

func response(object: Dictionary) -> void:
	var notice: Dictionary = fields.iterate(object, fields.response)
	var last = object.connection.data.back()
	if last: last.notice = notice

func _severity(object: Dictionary, field: Dictionary) -> void:
	object.backend.connection.meta.result.error["severity"] = field.value
	if fields.is_fatal(field.value):
		object.backend.connection.reset()
		object.backend.connection.note.ask_for_closure(true)

func _message(object: Dictionary, field: Dictionary) -> void:
	object.backend.connection.meta.result.error["message"] = field.value
	object.backend.connection.note.fail(field.value)

func error(object: Dictionary) -> void: 
	var failure: Dictionary = object.backend.connection.meta.result.error
	fields.iterate(object, fields.error(self, object))
	if failure.has("severity") and fields.is_fatal(failure["severity"]):
		object.connection.fail_auth()

func parse(type: String, object: Dictionary) -> bool:
	match type:
		'E': error(object)
		'N': response(object)
		_: return false
	return true
