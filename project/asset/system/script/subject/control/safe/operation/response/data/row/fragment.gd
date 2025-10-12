extends Node

class_name DataRowFragment

const RAW: int = 1

var matcher: PostgresDataTypes = PostgresDataTypes.new()
var responses: BackendResponses:
	get: return matcher.backend.responses

func null_the_result(rows: Array) -> int:
	for row in rows: row.append(null)
	return 0
	
func _set_value(from: int, to: int) -> void:
	matcher.backend.value = responses.fragments.slice(from, to)

func _append_raw(rows: Array, i: int) -> void:
	var result: PostgreSQLQueryResult = responses.buffer.result
	if result.get_type_object_id(i):
		rows[RAW].append(matcher.backend.value.get_string_from_utf8)
	else:
		rows[RAW].append(matcher.backend.value)

func resolution(rows: Array, offset: Dictionary, i: int) -> void:
	_set_value(offset.next, offset.next + offset.length)
	matcher.resolve(i)
	if not matcher.stop: _append_raw(rows, i)

func add_row(data_row: Array, raw_data: Array) -> void:
	var result: PostgreSQLQueryResult = responses.buffer.result
	result.data_row.append(data_row) # The result.
	result.raw_data.append(raw_data)

func start(result: Array) -> void:
	matcher.stop = false
	responses.fragments.set_cursor(0)
	matcher.backend.row = result
