extends Node

class_name SaslChallengeParameters

enum { NONCE = 0, SALT = 1, ITERATIONS = 2 }
const QUERY_SKIP: int = 2

var stats: SaslAuthenticationStats
var word: PackedByteArray:
	get: return stats.backend.credit.word.to_utf8_buffer()

func _stored_key(client_key: PackedByteArray) -> PackedByteArray:
	var hashes: HashingContext = HashingContext.new()
	hashes.start(EncryptionSASL.HASH)
	hashes.update(client_key)
	return hashes.finish()

func _extract(params: Array, no: int) -> String: return params[no].substr(QUERY_SKIP)

func get_server(message: String) -> Dictionary:
	var params: Array = message.split(',')
	var salt: String = _extract(params, SALT)
	return {
		"iterations": _extract(params, ITERATIONS).to_int(),
		"salt": Marshalls.base64_to_raw(salt),
		"nonce": _extract(params, NONCE)
	}

func get_client_side(type: HashingContext.HashType, salted_pass: PackedByteArray) -> Dictionary:
	var crypto: Crypto = Crypto.new()
	var client: PackedByteArray = crypto.hmac_digest(type, salted_pass, stats.key("Client"))
	var auth: PackedByteArray = stats.message.auth.to_utf8_buffer()
	return { "key": client, "signature": crypto.hmac_digest(type, _stored_key(client), auth) }
