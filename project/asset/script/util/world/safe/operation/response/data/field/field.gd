extends RefCounted

class_name FieldDescriptionResponses

const TERMINATOR: int = 0

var data: DataRowResponse = DataRowResponse.new()
var specific: FieldSpecific = FieldSpecific.new()

func _measure_name() -> int:
	var octets: PackedByteArray = specific.no.responses.fragments.word()
	var field_name: String = ""
	for octet in octets:
		field_name += char(octet)
		if octet == TERMINATOR: break
	return len(field_name)

func row() -> void:
	for _index in specific.get_fields_number(true):
		var length: int = _measure_name()
		specific.add_fields(length)
	print("RESULT FIELDS: ", specific.no.responses.buffer.result.row_description)

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
