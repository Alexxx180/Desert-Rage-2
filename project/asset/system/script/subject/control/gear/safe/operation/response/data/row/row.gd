extends RefCounted

class_name DataRowResponse

signal stop()

var cursor: DataRowCursor = DataRowCursor.new()

func null_the_result(rows: Array) -> int:
	for row in rows:
		row.append(null)
	return 0

func resolve(rows: Array, next: int, length: int, i: int) -> int:
	if length == cursor.NULL: return null_the_result(rows)
	cursor.resolution(rows, next, length, i)
	return length

func row_response() -> void:
	var raw: Array = []
	var result: Array = []
	
	cursor.start(result)
	var i: int = 0
	while i < cursor.columns and cursor.searching:
		cursor.fields_column(i, result, raw, resolve)
		i += 1
	if cursor.searching:
		cursor.add_row(result, raw)
	else:
		stop.emit()
