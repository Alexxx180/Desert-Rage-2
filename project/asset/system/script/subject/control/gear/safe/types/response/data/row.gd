extends RefCounted

class_name DataRowResponse

enum CURSOR { ADD = 4, START = 7, NEXT = 11 }

var _matcher: PostgresDataTypes = PostgresDataTypes.new()
var _stop: bool
var responses: BackendResponses:
	get: return _matcher.object.responses
	set(value): _matcher.object.responses = value
var note: PostgreClientNotify:
	set(value): _matcher.object.note = value

func get_number_of_columns() -> int: # Number of column values that follow - can be 0.
	return responses.reverse(4, 5, 7).get_16()

func get_message_length(cursor: int, next: int) -> int:
	return responses.reverse(0, cursor + CURSOR.START, next).get_32()

func data_row_response() -> bool: 
	var _stop: bool = false
	var columns: int = get_number_of_columns()

	var raw: Array = []
	var row: Array = []
	_matcher.object.row = row

	var cursor: int = 0
	var i: int = 0
	while i < columns and not _stop: # Next, the following pair of fields appear for each column.
		_matcher.object.responses.buffer = StreamPeerBuffer.new()

		var next: int = cursor + CURSOR.NEXT
		var length: int = get_message_length(cursor, next)
		
		if length == -1:
			for r in [row, raw]: r.append(null)
			length = 0 ### NULL ### The result
		else:
			_matcher.object.value = _matcher.object.responses.slice(next, next + length) # var error: int
			_stop = _matcher.resolve(i)
			if not _stop: raw_row.append(reponses.result.verify())

		cursor += length + CURSOR.ADD
		i += 1
	if not _stop:
		_matcher.object.reponses.result.data_row.append(row)# The result.
		reponses.result.raw_data.append(raw)
	return _stop
