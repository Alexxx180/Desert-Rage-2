extends RefCounted

## The PostgreSQLQueryResult class is a subclass of PostgreSQLClient which is not intended to be created manually. It represents the result of an SQL query and provides an information and method report to use the result of the query. It is usually returned by the PostgreSQLClient.execute() method in an array of PostgreSQLQueryResult.
class_name PostgreSQLQueryResult

const UNKNOWN_TYPE: int = -1

var fields_number: int = 0 ## Specifies the number of fields in a row (can be zero).

var row_description: Array = [] ## An array that contains dictionaries. These dictionaries represent the description of the rows where the query was executed. The number of dictionary depends on the number of fields resulting from the result of the query which was executed.

# Below arrays that contains sub-arrays. These sub-arrays represent for most of the queries the rows of the table where the query was executed. The number of sub-tables depends on the query that has been made. These sub-arrays contain as many elements as fields_number. 
var data_row: Array = [] ## These elements are native GDscript types that represent the data resulting from the query.

## Note that the frontend does not check the validity of the data, so you have to check the data manually. Sub-array data types are of type String if row_description.["format_code"] is 0 and of type PackedByteArray if 1.
var raw_data_row: Array = [] ## Unlike data_row which contains elements of native GDscript types, raw_data_row contains the raw data sent by the backend which represents the raw data resulting from the query instead of converting it to a native GDScript type.

var command_tag: String ## Complete SQL command word identifier

var notice: Dictionary = {} ## Represents various information about the execution status of the query notified by the backend. Can be empty.

func _compare_field(name: String, i: int) -> bool:
	return row_description[i]["field_name"] == name

func _set_values_data(values: Array, fields_index: int) -> void:
	for data in data_row: values.append(data[fields_index])

func unresolved_values() -> Array: return []

## Get all the values of a field by its "name", case sensitive
func get_field_values(field_name: String) -> Array:
	var values: Array = unresolved_values()
	var i: int = 0
	while i < fields_number and !_compare_field(field_name, i): i += 1
	
	if i != fields_number: _set_values_data(values, i)

	return values

func verify(i: int, data):
	return data.get_string_from_utf8() if get_type_object_id(i) else data

func get_type_object_id(i: int): return row_description[i]["type_object_id"]

## Get the data type object ID of field by its "name", case sensitive.
func field_data_type(name: String) -> int:
	for i in fields_number:
		if _compare_field(name, i):
			return get_type_object_id(i)
	return UNKNOWN_TYPE
