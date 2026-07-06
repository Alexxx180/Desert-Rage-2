extends RefCounted

class_name AuthResponse

enum { START = 5, END = 9 }

var sasl: EncryptionSASL = EncryptionSASL.new()
var base: EncryptionAuth = EncryptionAuth.new()

func encryption(type: int) -> bool:
	return base.encryption(type) or sasl.encryption(type)
	
func encrypted(type: int) -> bool:
	return base.no_support(type) or encryption(type) or base.no_response()

func response() -> void: # Identifies the message as an authentication request.
	var responses: BackendResponses = sasl.main.params.stats.backend.responses
	var buffer: StreamPeerBuffer = responses.reverse(ResponsesBuffer.AUTH, START, END)
	encrypted(buffer.get_32())

func parse(type: String, _object: Dictionary) -> bool:
	match type:
		'K': base.cancel()
		'R': response()
		_: return false
	return true
