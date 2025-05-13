extends RefCounted

class_name PostgresStringRecognize

signal stop()

func _end(object: Dictionary, type: String, postfix: String = "") -> void:
	object.note.end_response(object.responses, "invalid_value", type + " - " + postfix)
	stop.emit()

func string(object: Dictionary) -> void: # Returns String as result
	object.row.append(object.value.get_string_from_utf8())

func latin(row: Array, value_data, response) -> void:
	row.append(value_data.get_string_from_ascii())

func xml(object: Dictionary) -> void:
	var xml: XMLParser = XMLParser.new()
	var code: Error = xml.open_buffer(object.value)
	if code != OK: _end(object, "XML", "Error: %d" % code)
	else: string(object)

func _json_error(object: Dictionary, type: String, json: JSON, code: Error) -> void:
	var message: String = json.get_error_message()
	var line: int = json.get_error_line()
	_end(object, "invalid_value", str(type, " - ", message, " - line: ", line, " - code: ", code))

func json(object: Dictionary, type: String = "JSON") -> void:
	var text: String = object.value.get_string_from_utf8()
	var json: JSON = JSON.new()
	var code: Error = json.parse(text)
	if code != OK: _json_error(object, type, json, code)
	else: object.row.append(text)

func binary_json(object: Dictionary) -> void: # Returns String as result
	return json(object, "JSONB")
