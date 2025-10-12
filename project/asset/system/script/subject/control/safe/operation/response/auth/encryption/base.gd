extends RefCounted

class_name EncryptionAuth

var backend: Dictionary

func no_support(type: int) -> bool:
	var stop: bool = type == 2 or (6 <= type and type <= 9)
	if stop:
		var types: Dictionary = { 2: "KerberosV5", 6: "SCMCredential", 7: "GSS", 8: "GSSContinue", 9: "SSPI" }
		backend.connection.note.end_response("no_support", "Authentication" + types[type])
	return stop

func _successful_auth() -> void:
	backend.connection.status.start_connecting()

func _clear_text() -> PackedByteArray:
	backend.responses.resize()
	return backend.op.requests.p(backend.credit.word.to_utf8_buffer())

func _get_md5_hex(context: HashingContext) -> PackedByteArray:
	return ("md5" + context.finish().hex_encode()).to_ascii_buffer()

func _get_key() -> PackedByteArray:
	return backend.credit.merge().md5_buffer().hex_encode().to_ascii_buffer()

func _md5_encryption() -> PackedByteArray:
	var op: BufferOperations = backend.op
	var context: HashingContext = HashingContext.new()
	context.start(HashingContext.HASH_MD5)
	context.update(_get_key() + backend.responses.fragments.slice(9, 13))
	backend.responses.resize()
	return op.requests.p(_get_md5_hex(context) + op.byte)

func no_response() -> bool:
	backend.connection.note.end_response("no_auth_support")
	return true

func cancel() -> void: backend.credit.cancel(backend.responses)

func encryption(type: int) -> bool:
	match type:
		0: _successful_auth()
		3: _clear_text()
		5: _md5_encryption()
		_: return false
	return true
