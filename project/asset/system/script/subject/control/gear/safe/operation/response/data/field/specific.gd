extends RefCounted

class_name FieldSpecific

enum { START = 7, ADD = 5 }

var no: FieldNumbers = FieldNumbers.new()

func _reverse(seek: int, start: int) -> StreamPeerBuffer:
	return no.responses.ireverse(start, seek)

func get_fields_number(overwrite: bool = false) -> int: # can be 0
	no.responses.message.cursor = START
	var number: int = no.fields_number
	if overwrite: no.responses.result.fields_number = number
	return number

func add_fields(field_name_length: int) -> void:
	no.responses.message.cursor += field_name_length
	no.responses.buffer = StreamPeerBuffer.new()
	no.responses.result.row_description.append(no.get_fields()) # The result.

func add_parameter(types: Array, index: int) -> void:
	var seek: int = no.responses.message.cursor + index - 1
	types.append(_reverse(seek, ADD).get_32()) # Get object ID of the parameter data type.
	no.responses.cursor += ADD
