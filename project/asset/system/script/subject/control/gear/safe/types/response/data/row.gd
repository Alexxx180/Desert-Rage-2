extends RefCounted

class_name FieldDescriptionReponses

const START_CURSOR: int = 7

func _find_field_name_length(octets: PackedByteArray) -> int:
	var field: Dictionary = { "name": "", "octet": 0 }
	while field.octet < octets.size():
		field.name += char(octets[field.octet])
		field.octet += 1
	return len(field)

func get_fields_number() -> int: # can be 0
	responses.message.cursor = START_CURSOR
	return responses.reverse(4, 5, 7).get_u16()

func row(responses: BackendResponses) -> void:
	query_result.number_of_fields_in_a_row = get_fields_number()
	for _index in query_result.number_of_fields_in_a_row:
		responses.message.cursor += _find_field_name_length(responses.slice(1))
		responses.buffer = StreamPeerBuffer.new()
		var fields: Dictionary = { # Get the ... if field is specific table column: otherwise 0
			"table_object_id": responses.reverse(0, 5).get_u32(), # ... table object ID ...
			"column_index": responses.reverse(4, 2).get_u16(), # ... column attribute number ...
			"type_object_id": responses.reverse(6, 4).get_u32(), # field's data type object ID
			"data_type_size": responses.reverse(10, 2).get_u16(), # data type size
			"type_modifier": responses.reverse(12, 4).get_u32(), # type modifier. The meaning is type-specific.
			"format_code": responses.reverse(16, 2).get_u16() # field used format code. 0 (text, default) / 1 (binary).
		} # Note that negative values denote variable-width types. See also pg_type.typlen, pg_attribute.atttypmod
		query_result.row_description.append(fields)# The result.

func parameter(responses: BackendResponses) -> void: 
	var types: Array = []
	for index in get_fields_number(): # used by the statement
		var seek: int = responses.message.cursor + index - 1
		types.append(responses.reverse(seek, 5).get_32()) # Get object ID of the parameter data type.
		cursor += 5
	print(types) # The result.
