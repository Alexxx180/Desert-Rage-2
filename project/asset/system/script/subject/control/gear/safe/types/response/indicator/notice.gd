extends RefCounted

class_name NoticeResponses # consists of 1+ fields in any order, followed by \0 terminator.

const FIELD_TYPE: int = 1

var connection: ConnectionMetadata

func _get_match_fields() -> Dictionary:
	return {
		'V': "severity_no_localized", 'C': "SQLSTATE_code", 'D': "detail", 'H': "hint",
		'P': "position", 'p': "internal_position", 'q': "internal_query", 'W': "where",
		's': "schema_name", 't': "table_name", 'c': "column_name", 'd': "constraint_name",
		'n': "constraint_name", 'F': "file", 'L': "line", 'R': "routine"
	}

func _match_response(data, value, field, keys: Dictionary, feedback: Dictionary) -> void:
	if feedback.has(field): feedback[field].call(value) # Note: unrecognized types (e.g. not implemented)
	elif keys.has(field): data[keys[field]] = value # should be silently ignored

func _get_field(champ: String) -> Dictionary:
	var code = champ[FIELD_TYPE] # field if \0 message terminator else no string follows.
	return { "type": code, "value": champ.trim_prefix(code) }

func _iterate_fields(set_feedback: Callable) -> Dictionary:
	var notice_object: Dictionary = {}
	for champ_data in responses.split_byte(5, 0):
		var field: Dictionary = _get_field(champ_data.get_string_from_ascii())
		var keys: Dictionary = _get_match_fields()
		var feedback: Dictionary = set_feedback.call(keys, field)
		_match_response(notice_object, field.value, field.type, keys, feedback)
	return notice_object

func response() -> void:
	var notice: Dictionary = iterate_fields(func(keys, _f):
		keys['S'] = "severity"
		keys['M'] = "message"
		return Defaults.DICT)
	var last = connection.data.back()
	if last: last.notice = notice

func _severity(field) -> void:
	connection.status.error["severity"] = field.value
	if field.value == "FATAL":
		connection.reset()
		connection.note.ask_for_closure(true)

func _message(field) -> void:
	connection.status.error["message"] = field.value
	connection.note.fail(field.value)

func error() -> void: 
	iterate_fields(func(_k, field): return { 'S': _severity, 'M': _message })
	if error_object["severity"] == "FATAL": connection.fail_auth()
