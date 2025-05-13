extends RefCounted

class_name DataRowResponse

enum CURSOR { RAW = 1, ADD = 4, START = 7, NEXT = 11 }

signal stop()

var _matcher: PostgresDataTypes = PostgresDataTypes.new()

func get_number_of_columns() -> int: # Number of column values that follow - can be 0.
	return _matcher.backend.responses.reverse(4, 5, 7).get_16()

func get_message_length(cursor: int, next: int) -> int:
	return _matcher.backend.responses.reverse(0, cursor + CURSOR.START, next).get_32()

func resolve(rows: Array, next: int, length: int, i: int) -> int:
	if length == -1:
		for row in rows: row.append(null)
		return 0 ### NULL ### The result
	else:
		_matcher.backend.value = _matcher.backend.responses.slice(next, next + length) # var error: int
		_matcher.resolve(i)
		if not _matcher.stop:
			rows[CURSOR.RAW].append(_matcher.backend.responses.result.verify())
	return length

func row() -> void:
	_matcher.stop = false
	var columns: int = get_number_of_columns()

	var raw: Array = []
	var row: Array = []
	_matcher.backend.row = row

	var cursor: int = 0
	var i: int = 0
	while i < columns and not _matcher.stop: # Next, the following pair of fields appear for each column.
		_matcher.backend.responses.buffer = StreamPeerBuffer.new()

		var next: int = cursor + CURSOR.NEXT
		var length: int = get_message_length(cursor, next)

		_matcher.backend.responses.cursor += resolve([row, raw], next, length, i) + CURSOR.ADD
		i += 1
	if not _matcher.stop:
		_matcher.backend.responses.result.data_row.append(row)# The result.
		_matcher.backend.responses.result.raw_data.append(raw)
	else:
		stop.emit()
