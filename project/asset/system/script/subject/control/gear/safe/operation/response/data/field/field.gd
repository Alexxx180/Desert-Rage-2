extends RefCounted

class_name FieldDescriptionResponses

var data: DataRowResponse = DataRowResponse.new()
var specific: FieldSpecific = FieldSpecific.new()

func _find_name_length(octets: PackedByteArray) -> int:
	var field: Dictionary = { "name": "", "octet": 0 }
	while field.octet < octets.size():
		field.name += char(octets[field.octet])
		field.octet += 1
	return len(field)

func row() -> void:
	for _index in specific.get_fields_number(true):
		specific.add_fields(_find_name_length(specific.responses.slice(1)))

func parameter() -> void:
	var types: Array = []
	for index in specific.get_fields_number(): # used by the statement
		specific.add_parameter(types, index)
	print(types) # The result.

func parse(type: String, _object: Dictionary) -> bool:
	match type:
		'D': data.row_response()
		'T': row()
		't': parameter()
		_: return false
	return true
