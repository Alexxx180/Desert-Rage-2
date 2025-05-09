extends RefCounted

class_name PostgresBytesRecognize

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
	else:_end(object, "BITEA")

func ip_address(object: Dictionary) -> void:
	var text = value_data.get_string_from_ascii()
	if not text.is_valid_ip_address():
		note.warn( + text)
	row.append(text)
