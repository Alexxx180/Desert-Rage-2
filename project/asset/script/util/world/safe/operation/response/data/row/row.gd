extends RefCounted

class_name DataRowResponse

signal stop()

var cursor: DataRowCursor = DataRowCursor.new()

func _last_row(result: Array, raw: Array) -> void:
	if cursor.searching:
		cursor.fragment.add_row(result, raw)
	else:
		stop.emit()

func _search_rows(result: Array, raw: Array) -> void:
	var i: int = 0
	while i < cursor.columns and cursor.searching:
		cursor.fields_column(i, result, raw)
		i += 1

func row_response() -> void:
	var raw: Array = []
	var result: Array = []
	cursor.fragment.start(result)
	_search_rows(result, raw)
	_last_row(result, raw)
