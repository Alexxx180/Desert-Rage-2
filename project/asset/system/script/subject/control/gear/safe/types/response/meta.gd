extends RefCounted

class_name MetaResponses

func get_the_option_name(number: int) -> void: for _option in number: pass # not recognized by the server...

func _number(responses, seek: int, start: int, end: int) -> void:
	return responses.reverse(seek, start, end).get_u32()

func negotiate_version() -> void: # Protocol version negotiation message:
	var minor_v: int = _number(responses, 4, 5, 9) # supported by the server for client major ver. request
	var options: int = _number(responses, 8, 9, 14) # of protocol options unrecognized by the server.
	get_the_option_name(options)
	prints(minor_v) # The result.

func length() -> bool: # Wait to receive full response.
	responses.buffer := StreamPeerBuffer.new()
	var data_length = response.reverse(0, 1, 5).get_u32()
	responses.message.length = buffer.size()
	return responses.size() < responses.message.length + 1 # Fragmentary check
