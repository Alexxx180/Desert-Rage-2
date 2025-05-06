extends RefCounted

## The PostgreSQLQueryResult class is a subclass of PostgreSQLClient which is not intended to be created manually. It represents the result of an SQL query and provides an information and method report to use the result of the query. It is usually returned by the PostgreSQLClient.execute() method in an array of PostgreSQLQueryResult.
class_name PostgreSQLQueryResult

## Specifies the number of fields in a row (can be zero).
var number_of_fields_in_a_row := 0

## An array that contains dictionaries. These dictionaries represent the description of the rows where the query was executed. The number of dictionary depends on the number of fields resulting from the result of the query which was executed.
var row_description := []

## An Array that contains sub-arrays. These sub-arrays represent for most of the queries the rows of the table where the query was executed. The number of sub-tables depends on the query that has been made. These sub-arrays contain as many elements as number_of_fields_in_a_row. These elements are native GDscript types that represent the data resulting from the query.
var data_row := []

## An Array that contains sub-arrays. These sub-arrays represent for most of the queries the rows of the table where the query was executed. The number of sub-tables depends on the query that has been made. These sub-arrays contain as many elements as number_of_fields_in_a_row.
## Unlike data_row which contains elements of native GDscript types, raw_data_row contains the raw data sent by the backend which represents the raw data resulting from the query instead of converting it to a native GDScript type.
## Note that the frontend does not check the validity of the data, so you have to check the data manually. Sub-array data types are of type String if row_description.["format_code"] is 0 and of type PackedByteArray if 1.
var raw_data_row := []

## This is usually a single word that identifies which SQL command was completed.
var command_tag: String

## Represents various information about the execution status of the query notified by the backend. Can be empty.
var notice := {}

func _compare_field(name: String, i: int) -> void:
	return row_description[i]["field_name"] == name

func _set_values_data(values: Array, fields_index: int) -> void:
	for data in data_row: values.append(data[fields_index])

## Returns all the values of a field. "field_name" is the name of the field on which we get the values. Can be empty if the field name is unknown. The "field_name" parameter is case sensitive.
func get_field_values(field_name: String) -> Array:
	var values := []
	var i: int = 0
	while i < number_of_fields_in_a_row and !_compare_field(field_name, i):
		i += 1
	
	if i != number_of_fields_in_a_row:
		_set_values_data(values, i)

	return values

func verify(i: int, data):
	return data.get_string_from_utf8() if get_type_object_id(i) else data

func get_type_object_id(i: int):
	return row_description[i]["type_object_id"]

## Returns the object ID of the data type of the field. "field_name" is the name of the field whose type we get. Can return -1 if the field name is unknown. The "field_name" parameter is case sensitive.
func field_data_type(field_name: String) -> int:
	for i in number_of_fields_in_a_row:
		if _compare_field(field_name, i):
			return get_type_object_id(i)
	return -1
