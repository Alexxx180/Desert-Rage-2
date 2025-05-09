extends RefCounted

class_name FieldDescriptionReponses

enum CURSOR { START = 7, ADD = 5 }

var data: DataRowResponse = DataRowResponse.new()

func _find_field_name_length(octets: PackedByteArray) -> int:
	var field: Dictionary = { "name": "", "octet": 0 }
	while field.octet < octets.size():
		field.name += char(octets[field.octet])
		field.octet += 1
	return len(field)

func _number16(seek: int, start: int) -> int:
	return data.responses.reverse(seek, start).get_u16()

func _number32(seek: int, start: int) -> int:
	return data.responses.reverse(seek, start).get_u32()

func get_fields_number() -> int: # can be 0
	data.responses.message.cursor = CURSOR.START
	return data.responses.reverse(4, 5, 7).get_u16()

func row(responses: BackendResponses) -> void:
	query_result.fields_number = get_fields_number()
	for _index in query_result.fields_number:
		data.responses.message.cursor += _find_field_name_length(data.responses.slice(1))
		data.responses.buffer = StreamPeerBuffer.new()
		var fields: Dictionary = { # Get the ... if field is specific table column: otherwise 0
			"table_object_id": _number32(0, 5), # ... table object ID ...
			"column_index": _number16(4, 2), # ... column attribute number ...
			"type_object_id": _number32(6, 4), # field's data type object ID
			"data_type_size": _number16(10, 2), # data type size
			"type_modifier": _number32(12, 4), # type modifier. The meaning is type-specific.
			"format_code": _number16(16, 2) # field used format code. 0 (text, default) / 1 (binary).
		} # Note that negative values denote variable-width types. See also pg_type.typlen, pg_attribute.atttypmod
		query_result.row_description.append(fields)# The result.

func parameter(responses: BackendResponses) -> void: 
	var types: Array = []
	for index in get_fields_number(): # used by the statement
		var seek: int = data.responses.message.cursor + index - 1
		types.append(data.responses.reverse(seek, CURSOR.ADD).get_32()) # Get object ID of the parameter data type.
		cursor += CURSOR.ADD
	print(types) # The result.
