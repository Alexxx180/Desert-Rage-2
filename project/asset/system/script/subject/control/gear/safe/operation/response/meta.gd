extends RefCounted

class_name MetaResponses

var responses: BackendResponses

func get_the_option_name(number: int) -> void:
	for _option in number: pass # not recognized by the server...

func _number(seek: int, start: int, end: int) -> int:
	return responses.reverse(seek, start, end).get_u32()

func negotiate_version() -> void: # protocol negotiation message:
	var minor_v: int = _number(4, 5, 9) # supported by the server for client major ver. request
	var options: int = _number(8, 9, 14) # of protocol options unrecognized by the server.
	get_the_option_name(options)
	prints(minor_v) # The result.

func fragment_check() -> bool: # Wait to receive full response.
	responses.buffer = StreamPeerBuffer.new()
	# var data_length: int = _number(0, 1, 5)
	responses.message.length = _number(0, 1, 5) # buffer.size()
	return responses.has_words() # Fragmentary check

func available(client: ConnectionClient) -> bool:
	var e = responses.enough()
	var c = client.connected()
	var f = fragment_check()
	print(e, c, f)
	return e and c and f

func parse(type: String, _object: Dictionary) -> bool:
	if type == 'v':
		negotiate_version()
		return true
	return false
