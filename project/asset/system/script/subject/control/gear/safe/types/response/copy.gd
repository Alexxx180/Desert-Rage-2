extends RefCounted

class_name CopyTypeResponse

func _number(responses, seek: int, start: int, end: int) -> int:
	return responses.reverse(1, 7, 10).get_16()

func format_column_codes() -> void: # Must be 0 "text" / 1 "binary"
	var columns_to_copy: int = _number(responses, 1, 7, 10)
	for number in columns_to_copy:
		var seek: int = 2 * number + 3
		var code: int = _number(responses, seek, 10, 13)
		print(code) # The format code result.

func _get_overall_copy_format_code() -> int: # separation: 0. text as "rows [\r]\n, columns \t, etc"; 1. binary as "DataRow".
	return responses.reverse(0, 5, 7).get_8() # See COPY for more information.

func response(type: String) -> void: # Followed by copy data.
	responses.buffer = StreamPeerBuffer.new()
	_get_overall_copy_format_code()
	format_column_codes()
	note.warn("no_support", " Copy" + type + "Response")

func data() -> void: print(responses.slice(5, responses.length + 1)) # Get stream forming data part. Backend messages correspond single data rows.
func done() -> void: print("CopyDone") # COPY-complete indicator.
