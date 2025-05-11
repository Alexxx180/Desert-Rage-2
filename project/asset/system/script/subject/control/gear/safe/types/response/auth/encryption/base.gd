extends RefCounted

class_name EncryptionAuth

var note: PostgreClientNotify
var credit: EncryptionCredentials
var op: BufferOperations
var responses: BackendResponses

func supports(type: int) -> void:
	var stop: bool = type == 2 or (type >= 5 and type <= 10)
	if stop:
		var types: Dictionary = { 2: "KerberosV5", 6: "SCMCredential", 7: "GSS", 8: "GSSContinue", 9: "SSPI" }
		note.end_response(responses, "no_support", "Authentication" + types[type])
	return stop

func successful_auth() -> void:
	status = Status.CONNECTING

func _clear_text() -> PackedByteArray:
	return op.p(responses, credit.word.to_utf8_buffer())

func _get_md5_hex(context: HashingContext) -> String:
	return "md5" + context.finish().hex_encode()

func _md5_encryption() -> PackedByteArray:
	var key: PackedByteArray = credit.merge().md5_buffer()
	var context: HashingContext = HashingContext.new()
	context.start(HashingContext.HASH_MD5)
	context.update(key.hex_encode().to_ascii_buffer() + responses.slice(9, 13))
	return op.p(responses, _get_md5_hex(context).to_ascii_buffer() + byte())

func no_response() -> bool:
	note.end_response("no_auth_support")
	return true

func cancel() -> void: credit.cancel(responses)

func encryption(type: int) -> bool:
	match type:
		0: base.successful()
		3: base.clear_text()
		5: base.md5_encryption()
		_: return false
	return true
