extends RefCounted

class_name AuthResponse

var sasl: EncryptionSASL = EncryptionSASL.new()
var base: EncryptionAuth = EncryptionAuth.new()

func encryption(type: int) -> bool:
	return base.encryption(type) or sasl.encryption(type)
	
func encrypted(type: int) -> bool:
	return not base.supports(type) or encryption(type) or base.no_response()

func response() -> void: # Identifies the message as an authentication request.
	encrypted(sasl.main.stats.backend.responses.ireverse(10, 5).get_32())

func parse(type: String, _object: Dictionary) -> bool:
	match type:
		'K': base.cancel()
		'R': response()
		_: return false
	return true
