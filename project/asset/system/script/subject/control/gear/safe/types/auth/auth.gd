extends RefCounted

class_name AuthResponse

var sasl: EncryptionSASL = EncryptionSASL.new()
var base: EncryptionAuth = AuthSupport.new()

func response() -> bool: # Identifies the message as an authentication request.
	var authentication_type_data := responses.reverse(5, 10, 5)
	var authentication_type := buffer.get_32()
	var stop: bool = auth.check_support(authentication_type)
	if not stop:
		match authentication_type:
			0: base.successful()
			3: base.clear_text()
			5: base.md5_encryption()
			10: stop = sasl.encryption_start()
			11: stop = sasl.encryption_continue()
			12: stop = sasl.encryption_end()
			_: stop = base.no_response()
	return stop
