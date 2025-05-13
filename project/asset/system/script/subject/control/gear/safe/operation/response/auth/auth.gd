extends RefCounted

class_name AuthResponse

var sasl: EncryptionSASL = EncryptionSASL.new()
var base: EncryptionAuth = EncryptionAuth.new()

func encryption(type: int) -> bool:
	return base.encryption(type) or sasl.encryption(type)

func response() -> void: # Identifies the message as an authentication request.
	var type: int = sasl.main.stats.backend.responses.reverse(5, 10, 5).get_32()
	(not base.supports(type)) or encryption(type) or base.no_response()
