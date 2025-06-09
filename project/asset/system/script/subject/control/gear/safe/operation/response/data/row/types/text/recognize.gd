extends RefCounted

class_name TextPostgres

signal stop()

func _end(object: Dictionary, type: String, postfix: String = "") -> void:
	object.note.end_response(object.responses, "invalid_value", type + " - " + postfix)
	stop.emit()
	
static func ascii(object: Dictionary) -> String: return object.value.get_string_from_ascii()
static func utf8(object: Dictionary) -> String: return object.value.get_string_from_utf8()

func string(object: Dictionary) -> void: object.row.append(utf8(object))
func latin(object: Dictionary) -> void: object.row.append(ascii(object))

func xml(object: Dictionary) -> void:
	var parser: XMLParser = XMLParser.new()
	var code: Error = parser.open_buffer(object.value)
	if code != OK: _end(object, "XML", "Error: %d" % code)
	else: string(object)

func _json_error(object: Dictionary, type: String, _json: JSON, code: Error) -> void:
	var message: String = _json.get_error_message()
	var line: int = _json.get_error_line()
	_end(object, "invalid_value", str(type, " - ", message, " - line: ", line, " - code: ", code))

func json(object: Dictionary, type: String = "JSON") -> void:
	var text: String = utf8(object)
	var _json: JSON = JSON.new()
	var code: Error = _json.parse(text)
	if code != OK: _json_error(object, type, _json, code)
	else: object.row.append(text)

func binary_json(object: Dictionary) -> void: # Returns String as result
	return json(object, "JSONB")
