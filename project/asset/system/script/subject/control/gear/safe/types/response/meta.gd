extends RefCounted

class_name MetaResponses

var responses: BackendResponses

func get_the_option_name(number: int) -> void: for _option in number: pass # not recognized by the server...

func add_answer(fragment) -> void:
	responses.responses += fragment

func _number(responses, seek: int, start: int, end: int) -> void:
	return responses.reverse(seek, start, end).get_u32()

func negotiate_version() -> void: # protocol negotiation message:
	var minor_v: int = _number(responses, 4, 5, 9) # supported by the server for client major ver. request
	var options: int = _number(responses, 8, 9, 14) # of protocol options unrecognized by the server.
	get_the_option_name(options)
	prints(minor_v) # The result.

func enough() -> bool:
	return meta.responses.size() > 4

func fragment_check() -> bool: # Wait to receive full response.
	responses.buffer := StreamPeerBuffer.new()
	# var data_length: int = _number(responses, 0, 1, 5)
	responses.message.length = _number(responses, 0, 1, 5) # buffer.size()
	return responses.size() < responses.message.length + 1 # Fragmentary check
