extends RefCounted

class_name NoticeResponses # consists of 1+ fields in any order, followed by \0 terminator.

var _connection: ConnectionMetadata

func _get_match_fields() -> Dictionary:
	return {
		'V': "severity_no_localized", 'C': "SQLSTATE_code", 'D': "detail", 'H': "hint",
		'P': "position", 'p': "internal_position", 'q': "internal_query", 'W': "where",
		's': "schema_name", 't': "table_name", 'c': "column_name", 'd': "constraint_name",
		'n': "constraint_name", 'F': "file", 'L': "line", 'R': "routine"
	}

func _match_response(data, value, field, keys: Dictionary, feedback: Dictionary) -> void:
	if feedback.has(field): feedback[field].call() # Unrecognized types (e.g. not implemented)
	elif keys.has(field): data[keys[field]] = value # should be silently ignored

func _get_field(champ: String) -> Dictionary:
	var code = champ[0] # Identifies field type; if \0 message terminator else no string follows.
	return { "type": code, "value": champ.trim_prefix(code) }

func _iterate_fields(set_feedback: Callable) -> Dictionary:
	var notice_object: Dictionary = {}
	for champ_data in responses.split_byte(5, 0): # For each field there is the following:
		var field: Dictionary = _get_field(champ_data.get_string_from_ascii())
		var keys: Dictionary = _get_match_fields()
		var feedback: Dictionary = set_feedback.call(keys, field)
		_match_response(notice_object, field.value, field.type, keys, feedback)
	return notice_object

func response() -> void:
	var notice: Dictionary = iterate_fields(func(keys, _field):
		keys['S'] = "severity"
		keys['M'] = "message"
		return Defaults.DICT)
	var last = datas_command_sql.back()
	if last: last.notice = notice

func error() -> void: 
	iterate_fields(func(_keys, field):
		return {
			'S': func():
				error_object["severity"] = field.value
				if field.value == "FATAL":
					_connection.reset()
					note.ask_for_closure(true)
			'M': func():
				error_object["message"] = field.value
				note.fail(" " + field.value)
		}
	)
	if error_object["severity"] == "FATAL": _connection.fail_auth()
