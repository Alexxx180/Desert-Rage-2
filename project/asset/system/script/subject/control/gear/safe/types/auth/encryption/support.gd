extends RefCounted

class_name EncryptionAuth

var note: PostgreClientNotify
var credit: EncryptionCredentials
var op: BufferOperations
var responses: BackendResponses
# var message: BackendMessage

func check_support(type: int) -> void:# Specifies that the credentials message is required. No support
	var stop: bool = type == 2 or (type >= 5 and type <= 10)
	if stop:
		var types: Dictionary = { 2: "KerberosV5", 6: "SCMCredential", 7: "GSS", 8: "GSSContinue", 9: "SSPI" }
		note.end_response(response_buffer, "Authentication" + types[type] + " No support")
	return stop

func successful_auth() -> void:# Specifies that the authentication was successful.
	status = Status.CONNECTING

func _clear_text() -> PackedByteArray: # Specifies that a clear-text password is required.
	return op.p(responses, credit.word.to_utf8_buffer())

func _get_md5_hex(context: HashingContext) -> String:
	return "md5" + context.finish().hex_encode()

func _md5_encryption(): # Specifies that an MD5-encrypted password is required.
	var context: HashingContext = HashingContext.new()
	context.start(HashingContext.HASH_MD5)

	var key: PackedByteArray = credit.merge().md5_buffer()
	context.update(key.hex_encode().to_ascii_buffer() + responses.slice(9, 13))

	return op.p(responses, _get_md5_hex(context).to_ascii_buffer() + byte())

func no_response() -> bool:
	note.end_response("no_auth_support")
	return true
