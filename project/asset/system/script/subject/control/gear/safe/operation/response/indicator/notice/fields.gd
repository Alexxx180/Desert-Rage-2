extends RefCounted

class_name NoticeFields

enum { START = 5, END = 0, FIELD = 1 }

func _get_match_fields() -> Dictionary:
	return {
		'V': "severity_no_localized", 'C': "SQLSTATE_code", 'D': "detail", 'H': "hint",
		'P': "position", 'p': "internal_position", 'q': "internal_query", 'W': "where",
		's': "schema_name", 't': "table_name", 'c': "column_name", 'd': "constraint_name",
		'n': "constraint_name", 'F': "file", 'L': "line", 'R': "routine"
	}

func is_fatal(field_value: String) -> bool: return field_value == "FATAL"
func ascii(data: PackedByteArray) -> String: return data.get_string_from_ascii()

func _get_field(champ: String) -> Dictionary:
	var code = champ[FIELD] # field if \0 message terminator else no string follows.
	return { "type": code, "value": champ.trim_prefix(code) }

func _match(data: Dictionary, field: Dictionary, keys: Dictionary, feedback: Dictionary) -> void:
	if feedback.has(field.type): feedback[field.type].call(field.value) # Note: unrecognized types (e.g. not implemented)
	elif keys.has(field.type): data[keys[field.type]] = field.value # should be silently ignored

func iterate(object: Dictionary, set_feedback: Callable) -> Dictionary:
	var notice: Dictionary = {}
	for champ_data in object.responses.fragments.bytes(START, END):
		var keys: Dictionary = _get_match_fields()
		var field: Dictionary = _get_field(ascii(champ_data))
		var feedback: Dictionary = set_feedback.call(keys, field)
		_match(notice, field, keys, feedback)
	return notice

func response(keys: Dictionary, _field: Dictionary) -> Dictionary:
	keys['S'] = "severity"
	keys['M'] = "message"
	return Defaults.DICT

func error(notice: NoticeResponses, object: Dictionary) -> Callable:
	return func(_keys, field): return {
		'S': func(): notice.severity(object, field),
		'M': func(): notice.message(object, field)
	}
