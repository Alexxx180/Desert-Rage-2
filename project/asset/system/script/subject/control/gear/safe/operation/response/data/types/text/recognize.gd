extends RefCounted

class_name PostgresStringRecognize

signal stop()

const HEX: int = 2

func _end(object: Dictionary, type: String, postfix: String = "") -> void:
	object.note.end_response(object.responses, "invalid_value", type + " - " + postfix)
	stop.emit()

func string(object: Dictionary) -> void: # Returns String as result
	object.row.append(object.value.get_string_from_utf8())

func latin(row: Array, value_data, response) -> void:
	row.append(value_data.get_string_from_ascii())

func xml(object: Dictionary) -> bool:
	var xml: XMLParser = XMLParser.new()
	var code: Error = xml.open_buffer(object.value)
	if code != OK: _end(object, "XML", "Error: " + code)
	else: string(object)

func _json_error(object: Dictionary, json: JSON, code: Error) -> void:
	var message: String = json.get_error_message()
	var line: int = json.get_error_line()
	_end(object, "invalid_value", str(type, " - ", message, " - line: ", line, " - code: ", code))

func json(object: Dictionary, type: String = "JSON") -> bool:
	var text: String = object.value.get_string_from_utf8()
	var json: JSON = JSON.new()
	var code: Error = json.parse(text)
	if code != OK: _json_error(object, json, code)
	else: object.row.append(text)

func binary_json(object: Dictionary) -> void: # Returns String as result
	return add_json(object, "JSONB")
