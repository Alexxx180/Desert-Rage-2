extends RefCounted

class_name PostgresBytesRecognize

signal stop()

const HEX: int = 2

func _end(object: Dictionary, type: String) -> void:
	object.note.end_response(object.responses, type)
	stop.emit()

func get_number_from_hex(hex: Array, i) -> int:
	return (hex[i + 1] + hex[i + 2]).hex_to_int()

func latin(object: Dictionary) -> void:
	object.row.append(object.value.get_string_from_ascii())

func _add_bite_array(object: Dictionary) -> void:
	var bitea: PackedByteArray = PackedByteArray()
	for ihex in object.value.size() * 0.5 - 1:
		bitea.append(get_number_from_hex(object.value, ihex))
	object.row.append(bitea)

func bitea(object: Dictionary) -> void: # Support isn't complete
	var values: String = object.value.get_string_from_ascii()
	if values.substr(HEX).is_valid_hex_number():
		_add_bite_array(object)
	else: _end(object, "BITEA")

func ip_address(object: Dictionary) -> void:
	var text = object.value.get_string_from_ascii()
	if not text.is_valid_ip_address():
		object.connection.note.warn( + text)
	object.row.append(text)

func _todo(type: String) -> void: print("TODO '%s' type implementation" % type)
func timestamp(_object: Dictionary) -> void: _todo("TIMESTAMP")
func interval(_object: Dictionary) -> void: _todo("INTERVAL")
