extends RefCounted

class_name MetaResponses

var backend: Dictionary

func get_the_option_name(number: int) -> void:
	for _option in number: pass # not recognized by the server...

func _number(seek: int, start: int, end: int) -> int:
	return backend.responses.reverse(seek, start, end).get_u32()

func negotiate_version() -> void: # protocol negotiation message:
	var minor_v: int = _number(4, 5, 9) # supported by the server for client major ver. request
	var options: int = _number(8, 9, 14) # of protocol options unrecognized by the server.
	get_the_option_name(options)
	prints(minor_v) # The result.

func fragmented() -> bool: # Wait to receive full response.
	var responses: BackendResponses = backend.responses
	responses.buffer.renew()
	responses.fragments.message.length = _number(ResponsesBuffer.LENGTH, 1, 5)
	return responses.fragmented

func available() -> bool:
	var client: bool = backend.connection.client.connected()
	var enough: bool = backend.responses.enough
	var f = not fragmented()
	print(enough, client, f)
	return enough and client and f

func parse(type: String, _object: Dictionary) -> bool:
	if type == 'v':
		negotiate_version()
		return true
	return false
