extends RefCounted

class_name NoticeResponses # consists of 1+ fields in any order, followed by \0 terminator.

const FIELD_TYPE: int = 1
# var connection: ConnectionMetadata
func _get_match_fields() -> Dictionary:
	return {
		'V': "severity_no_localized", 'C': "SQLSTATE_code", 'D': "detail", 'H': "hint",
		'P': "position", 'p': "internal_position", 'q': "internal_query", 'W': "where",
		's': "schema_name", 't': "table_name", 'c': "column_name", 'd': "constraint_name",
		'n': "constraint_name", 'F': "file", 'L': "line", 'R': "routine"
	}

func _match(data: Dictionary, field: Dictionary, keys: Dictionary, feedback: Dictionary) -> void:
	if feedback.has(field.type): feedback[field.type].call(field.value) # Note: unrecognized types (e.g. not implemented)
	elif keys.has(field.type): data[keys[field.type]] = field.value # should be silently ignored

func _get_field(champ: String) -> Dictionary:
	var code = champ[FIELD_TYPE] # field if \0 message terminator else no string follows.
	return { "type": code, "value": champ.trim_prefix(code) }

func _iterate_fields(object: Dictionary, set_feedback: Callable) -> Dictionary:
	var notice: Dictionary = {}
	for champ_data in object.responses.split_byte(5, 0):
		var keys: Dictionary = _get_match_fields()
		var field: Dictionary = _get_field(champ_data.get_string_from_ascii())
		var feedback: Dictionary = set_feedback.call(keys, field)
		_match(notice, field.value, field.type, keys, feedback)
	return notice

func response(object: Dictionary) -> void:
	var notice: Dictionary = iterate_fields(object,
	func(keys, _f):
		keys['S'] = "severity"
		keys['M'] = "message"
		return Defaults.DICT)
	var last = connection.data.back()
	if last: last.notice = notice

func _severity(object: Dictionary, field: Dictionary) -> void:
	object.connection.status.error["severity"] = field.value
	if field.value == "FATAL":
		object.connection.reset()
		object.connection.note.ask_for_closure(true)

func _message(object: Dictionary, field: Dictionary) -> void:
	object.connection.status.error["message"] = field.value
	object.connection.note.fail(field.value)

func error(object: Dictionary) -> void: 
	iterate_fields(object, func(_k, field): return {
		'S': func(f): _severity(object, f), 'M': func(f): _message(object, f)})
	if error_object["severity"] == "FATAL": connection.fail_auth()
