extends RefCounted

class_name SaslChallenge

enum { NONCE = 0, SALT = 1, ITERATIONS = 2 }
const QUERY_SKIP: int = 2

var stats: SaslAuthenticationStats

func _stored_key_from(key: PackedByteArray) -> PackedByteArray:
	var hashes: HashingContext = HashingContext.new()
	hashes.start(stats.salt.context)
	hashes.update(key)
	return hashes.finish()
	
func get_param(params: Array, no: int) -> String:
	return params[no].substr(QUERY_SKIP)

func _get_server_params(message: String) -> Dictionary:
	var params: Array = message.split(',')
	return {
		"iterations": get_param(params, ITERATIONS).to_int(),
		"salt": Marshalls.base64_to_raw(get_param(params, SALT)),
		"nonce": get_param(params, NONCE)
	}

func _set_auth_message(client: Dictionary, server: String) -> void: # initial client message, server challenge, client response without proof.
	client.first = stats.client_safe()
	stats.message.auth = client.first + ',' + server + ',' + client.final

func _get_proof() -> PackedByteArray:
	var crypto: Crypto = Crypto.new()
	var client: Dictionary = { "key": stats.salt.hmac(crypto, stats.salt.output, stats.key("Client")) }
	client.signature = stats.salt.hmac(crypto, _stored_key_from(client.key), stats.message.auth.to_utf8_buffer())
	return stats.get_proof(client)

func _get_final_client_message() -> String:
	var message: Dictionary = { "first": stats.get_server_message(), "client": {} }
	var server: Dictionary = _get_server_params(message.first)

	message.client.final = "c=biws,r=" + server.nonce
	stats.salt.pbkdf2(stats.backend.credit.word.to_utf8_buffer(), server)
	_set_auth_message(message.client, message.first)
	message.client.proof = Marshalls.raw_to_base64(_get_proof())

	return message.client.final + ",p=" + message.client.proof

func encryption() -> void: # Specifies that this message contains a SASL challenge. SCRAM-SHA-256
	var final: String = _get_final_client_message()
	var auth: PackedByteArray = stats.backend.op.requests.p(final.to_ascii_buffer())
	stats.put_ssl_initial(auth)
