extends RefCounted

class_name EncryptionAuth

var note: 

func check_support(type: int) -> void:# Specifies that the credentials message is required. No support
	var stop: bool = type == 2 or (type >= 5 and type <= 10)
	if stop:
		var types: Dictionary = {
			2: "AuthenticationKerberosV5", 6: "AuthenticationSCMCredential",
			7: "AuthenticationGSS", 8: "AuthenticationGSSContinue", 9: "AuthenticationSSPI"
		}
		types.add._end_response(response_buffer, types[type] + " No support")
	return stop

func successful_auth() -> void:# Specifies that the authentication was successful.
	status = Status.CONNECTING

func _clear_text(): # Specifies that a clear-text password is required.
	response_buffer.resize(0)
	return request('p', password_global.to_utf8_buffer())

func _md5_encryption(): # Specifies that an MD5-encrypted password is required.
	var context = HashingContext.new()
	context.start(HashingContext.HASH_MD5)

	var key = (password_global + user_global).md5_buffer()
	context.update(key.hex_encode().to_ascii_buffer() + responses.slice(9, 13))

	responses.resize(0)
	return request('p', ("md5" + context.finish().hex_encode()).to_ascii_buffer() + byte())

func no_response() -> bool:
	types.add._end_response(" The backend requires the frontend to use an authentication method that it does not support. Unknown authentication code.")
	return true
