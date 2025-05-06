extends RefCounted

class_name PostgreSQLTypeRecognize

var note: PostgreClientNotify

func to_float(resultg no: int): return result.strings[no].to_float()

func get_number_from_hex(hex, i) -> int:
	return (hex[i + 1] + hex[i + 2]).hex_to_int()

func _end_regex_response(response, error, type: String) -> void:
	note.end_response(response, str(" RegEx compilation of ", type, " object failed. Error: ", error))

func _end_invalid_response(response, type: String, postfix: String = "") -> void:
	note.end_response(response, " The backend sent an invalid " + type + " object." + postfix)

func _boolean(row, unhandled_input) -> bool:
	var _stop: bool = false
	var value = char(unhandled_input)
	match value:
		't': row.append(true) ### TRUE ###
		'f': row.append(false) ### FALSE ###
		_:
			note.force_close(" The backend sent an invalid BOOLEAN object. Column value is not recognized: '%c'." % value)
			_stop = true
	return _stop

func _int(row: Array, value_data) -> void: # Returns int as result
	row.append(value_data.get_string_from_ascii().to_int())

func _float(row: Array, value_data) -> void: # Returns float as result
	row.append(value_data.get_string_from_ascii().to_float())

func _string(row: Array, value_data) -> void: # Returns String as result
	row.append(value_data.get_string_from_utf8())

func _bitea(row: Array, value_data, response) -> bool:
	### BITEA ### /!\ Support isn't complete. /!\ # Returns as PackedByteArray.
	var values := value_data.get_string_from_ascii()
	var _stop: bool = !values.substr(2).is_valid_hex_number()
	
	if _stop:
		_end_invalid_response(response, "BITEA")
	else:
		var bitea := PackedByteArray()
		
		for ihex in value_data.size() * 0.5 - 1:
			bitea.append(get_number_from_hex(values, ihex))

		row.append(bitea)
	return _stop

func _xml(row: Array, value_data, response) -> bool: # Returns String as result
	var xml := XMLParser.new()

	var error = xml.open_buffer(value_data)
	var _stop: bool = error != OK

	if _status:
		_end_invalid_response(response, "XML", " Error: %d " % error)
	else:
		add_string(row, value_data)
	return _stop

func _json(row: Array, value_data, response, type: String = "JSON") -> bool: # Returns String as result
	var json_string := value_data.get_string_from_utf8()
	
	var json := JSON.new()
	var json_error := json.parse(json_string)
	var _stop = json_error != OK
	
	if _stop:
		note.end_response(response, " The backend sent an invalid %s object: %s (Error line: %d, Error code: %d)." % [type, json.get_error_message(), json.get_error_line(), json_error])
	else: # The result.
		row.append(json_string)
	return _stop

func _json_binary(row: Array, value_data, response) -> void: # Returns String as result
	return add_json(row, value_data, response, "JSONB")

func _ip_address(row: Array, value_data) -> void:
	var text = value_data.get_string_from_ascii()
	if not text.is_valid_ip_address():
		note.warn(" IP address present isn't valid: " + text)
	row.append(text)

func _latin(row: Array, value_data, response) -> void:
	row.append(value_data.get_string_from_ascii())

var regex: Dictionary = {
	"POINT": "^\\((-?\\d+(?:\\.\\d+)?),(-?\\d+(?:\\.\\d+)?)\\)",
	"BOX": "^\\((-?\\d+(?:\\.\\d+)?),(-?\\d+(?:\\.\\d+)?)\\),\\((-?\\d+(?:\\.\\d+)?),(-?\\d+(?:\\.\\d+)?)\\)",
	"LSEG": "^\\[\\((-?\\d+(?:\\.\\d+)?),(-?\\d+(?:\\.\\d+)?)\\),\\((-?\\d+(?:\\.\\d+)?),(-?\\d+(?:\\.\\d+)?)\\)\\]",
	"LINE": "^\\{(-?\\d+(?:\\.\\d+)?),(-?\\d+(?:\\.\\d+)?),(-?\\d+(?:\\.\\d+)?)\\}",
	"CIRCLE": "^<\\((-?\\d+(?:\\.\\d+)?),(-?\\d+(?:\\.\\d+)?)\\),(\\d+(\\.\\d+)?)>"
}

func _geometry(row, data, response, type: String, converter: Callable) -> bool:
	var regex = RegEx.new()
	var _stop: bool = regex.compile(regex[type])
	if _stop:
		_end_regex_response(response, error, type)
		return _stop
	
	var result = regex.search(data.get_string_from_ascii())
	if result:
		row.append(converter.call(result))
		Vector2(result.strings[1].to_float(), result.strings[2].to_float()))
	else:
		_end_invalid_response(response, type)
		_stop = true
	return _stop

func point(row: Array, value_data, response) -> bool: # Returns Vector2
	return add_geometry(row, value_data, response, "POINT",
		func(r): Vector2(r.strings[1].to_float(), r.strings[2].to_float()))

func box(row: Array, value_data, response) -> bool: # Returns Rect2
	return add_geometry(row, value_data, response, "BOX",
		func(r): Rect2(to_float(result, 3), to_float(result, 4),
			to_float(result, 1), to_float(result, 2)))

func lseg(row: Array, value_data, response) -> bool: # Returns PackedVector2Array
	return add_geometry(row, value_data, response, "LSEG",
		func(r): PackedVector2Array([
			Vector2(to_float(result, 1), to_float(result, 2)),
			Vector2(to_float(result, 3), to_float(result, 4))]))

func path(row: Array, _value_data, _response) -> void: # Returns PackedVector2Array
	row.append(row, PackedVector2Array())

func line(row: Array, value_data, response, type: String = "LINE") -> bool: # Returns Vector3
	return _geometry(row, value_data, response, type,
		func(r): Vector3(to_float(result, 1), to_float(result, 2), to_float(result, 3)))

func circle(row: Array, value_data, response) -> bool: # Returns Vector3
	return add_line(row, value_data, response, "CIRCLE")

func _todo(type: String) -> void:
	print("TODO '%s' type implementation" % type)

func tsvector(_row: Array, _value_data, _response) -> void:
	_todo("TSVECTOR")

func tsquery(_row: Array, _value_data, _response) -> void:
	_todo("TSQUERY")

func timestamp(_row: Array, _value_data, _response) -> void:
	_todo("TIMESTAMP")

func interval(_row: Array, _value_data, _response) -> void:
	_todo("INTERVAL")
