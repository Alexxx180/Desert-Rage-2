extends RefCounted

class_name FieldSpecific

enum { START = 7, ADD = 5 }

var no: FieldNumbers = FieldNumbers.new()

func get_fields_number(overwrite: bool = false) -> int: # can be 0
	no.responses.fragments.set_cursor(START)
	print("CURSOR: ", no.responses.fragments.message.cursor)
	var number: int = no.fields_number
	if overwrite: no.responses.buffer.result.fields_number = number
	return number

func add_fields(field_name_length: int) -> void:
	no.responses.fragments.move_cursor(field_name_length)
	no.responses.buffer.renew()
	var fields: Dictionary = no.get_fields()
	no.responses.buffer.result.row_description.append(fields) # The result.

func add_parameter(types: Array, index: int) -> void:
	var seek: int = no.responses.fragments.message.cursor + index - 1
	types.append(no.buffer(ADD, seek).get_32()) # Get object ID of the parameter data type.
	no.responses.fragments.move_cursor(ADD)
