extends RefCounted

class_name FieldNumbers

var responses: BackendResponses
var fields_number: int:
	get: return responses.reverse(4, 5, 7).get_u16()

func buffer(a: int, seek: int) -> StreamPeerBuffer:
	return responses.cursor_reverse(a, seek)

func get_type_object_id() -> int:
	print("TYPE OBJECT ID CHECK")
	var r = buffer(3, 5).get_u32()
	print("TYPE OBJECT ID! ", r)
	return r

# Get the ... if field is specific table column: otherwise 0
var table_object_id: int:
	get: return buffer(4, 0).get_u16()
var column_attribute_number: int:
	get: return buffer(1, 3).get_u16()
var type_object_id: int:
	get: return buffer(3, 5).get_u32()
var data_type_size: int:
	get: return buffer(1, 9).get_u16()
var type_modifier: int:
	get: return buffer(3, 11).get_u32()
var format_code: int:
	get: return buffer(1, 15).get_u32()
# Note that negative values denote variable-width types. See also pg_type.typlen, pg_attribute.atttypmod

func get_fields() -> Dictionary:
	return { 
		"table_object_id": table_object_id,
		"column_index": column_attribute_number,
		"type_object_id": get_type_object_id(),
		"data_type_size": data_type_size,
		"type_modifier": type_modifier,
		"format_code": format_code
	}
