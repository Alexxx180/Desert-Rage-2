extends RefCounted

class_name CopyTypeResponses

var backend: Dictionary

func _number(seek: int, start: int, end: int) -> int:
	return backend.responses.reverse(seek, start, end).get_16()

func format_column_codes() -> void: # Must be 0 "text" / 1 "binary"
	var columns_to_copy: int = _number(1, 7, 10)
	for number in columns_to_copy:
		var seek: int = 2 * number + 3
		var code: int = _number(seek, 10, 13)
		print(code) # The format code result.

func _get_overall_copy_format_code() -> int: # Separation: 0. text as "rows [\r]\n, columns \t, etc"; 1. binary as "DataRow".
	return backend.responses.reverse(0, 5, 7).get_8() # See COPY for more information.

func response(type: String) -> void: # Followed by copy data.
	backend.responses.buffer = StreamPeerBuffer.new()
	_get_overall_copy_format_code()
	format_column_codes()
	backend.connection.note.warn("no_support", " Copy" + type + "Response")

func get_stream_data_part() -> PackedByteArray: return backend.responses.slice_word(5)
func copy_complete_indicator() -> String: return "CopyDone"

func data() -> void: print(get_stream_data_part()) # Backend messages correspond single data rows.
func done() -> void: print(copy_complete_indicator()) # COPY-complete indicator.

func parse(type: String, _object: Dictionary) -> bool:
	match type:
		'G': response("In")
		'H': response("Out")
		'W': response("Both")
		'c': done()
		'd': data()
		_: return false
	return true
