extends RefCounted

class_name DataRowCursor

enum { NULL = -1, RAW = 1, ADD = 4, START = 7, NEXT = 11 }

var _matcher: PostgresDataTypes = PostgresDataTypes.new()
var columns: int:
	get: return _matcher.backend.responses.reverse(4, 5, 7).get_16()
var searching: bool:
	get: return not _matcher.stop

func get_message_length(cursor: int, next: int) -> int:
	return _matcher.backend.responses.reverse(0, cursor + START, next).get_32()

func resolution(rows: Array, next: int, length: int, i: int) -> void:
	_matcher.backend.value = _matcher.backend.responses.fragments.slice(next, next + length)
	_matcher.resolve(i)
	if not _matcher.stop:
		rows[RAW].append(_matcher.backend.responses.result.verify())

func add_row(data_row: Array, raw_data: Array) -> void:
	var result = _matcher.backend.responses.result
	result.data_row.append(data_row) # The result.
	result.raw_data.append(raw_data)

func start(result: Array) -> void:
	_matcher.stop = false
	_matcher.backend.responses.cursor = 0
	_matcher.backend.row = result

func fields_column(i: int, result: Array, raw: Array, resolve: Callable) -> void:
	var responses: BackendResponses = _matcher.backend.responses
	responses.buffer.renew()

	var next: int = responses.cursor + NEXT
	var length: int = get_message_length(responses.cursor, next)

	responses.cursor += resolve.call([result, raw], next, length, i) + ADD
