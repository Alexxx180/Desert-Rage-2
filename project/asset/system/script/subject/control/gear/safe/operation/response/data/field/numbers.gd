extends RefCounted

class_name FieldNumbers

var responses: BackendResponses

func _buffer(start: int, seek: int) -> StreamPeerBuffer:
	return responses.ireverse(start, seek)

var fields_number: int:
	get: return responses.reverse(4, 5, 7).get_u16()

# Get the ... if field is specific table column: otherwise 0
var table_object_id: int:
	get: return _buffer(5, 0).get_u16()
var column_attribute_number: int:
	get: return _buffer(2, 4).get_u16()
var type_object_id: int:
	get: return _buffer(4, 6).get_u32()
var data_type_size: int:
	get: return _buffer(2, 10).get_u16()
var type_modifier: int:
	get: return _buffer(4, 12).get_u32()
var format_code: int:
	get: return _buffer(2, 16).get_u32()
# Note that negative values denote variable-width types. See also pg_type.typlen, pg_attribute.atttypmod

func get_fields() -> Dictionary:
	return { 
		"table_object_id": table_object_id,
		"column_index": column_attribute_number,
		"type_object_id": type_object_id,
		"data_type_size": data_type_size,
		"type_modifier": type_modifier,
		"format_code": format_code
	}
