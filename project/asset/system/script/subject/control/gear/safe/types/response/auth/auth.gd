extends RefCounted

class_name AuthResponse

var sasl: EncryptionSASL = EncryptionSASL.new()
var base: EncryptionAuth = AuthSupport.new()

func encryption(type: int, object: Dictionary) -> bool:
	return base.encryption(type, object) or sasl.encryption(type, object)

func response(object: Dictionary) -> bool: # Identifies the message as an authentication request.
	var type: int = object.responses.reverse(5, 10, 5).get_32()
	(not base.supports(type)) or encryption(type, object) or base.no_response()
