extends RefCounted

class_name DataRowCursor

enum { NULL = -1, ADD = 4, START = 7, NEXT = 11 }

var fragment: DataRowFragment = DataRowFragment.new()
var columns: int:
	get: return fragment.responses.reverse(4, 5, 7).get_16()
var searching: bool:
	get: return not fragment.matcher.stop

func get_message_length(cursor: int, next: int) -> int:
	return fragment.responses.reverse(0, cursor + START, next).get_32()

func _next_offset(cursor: int) -> Dictionary:
	var next: int = cursor + NEXT
	return { "next": next, "length": get_message_length(cursor, next) }

func resolve(fragments: ResponseFragments, rows: Array, i: int) -> void:
	HeroDeploy
	var offset: Dictionary = _next_offset(fragments.message.cursor)
	if offset.length == NULL:
		fragments.move_cursor(fragment.null_the_result(rows))
	else:
		fragment.resolution(rows, offset, i)
		fragments.move_cursor(offset.length + ADD)

func fields_column(i: int, result: Array, raw: Array) -> void:
	fragment.responses.buffer.renew()
	resolve(fragment.responses.fragments, [result, raw], i)
