extends RefCounted

class_name SaslChallenge

var stats: SaslAuthenticationStats

func get_first_server_message() -> String:
	return responses.slice_word(9).get_string_from_ascii()

func _substr(params: Array, i: int) -> String:
	return params[i].substr(2)

func get_stored_key(key: PackedByteArray):
	var hash: HashingContext = HashingContext.new()
	hash.start(stats.salt.type)
	hash.update(key)
	return hash.finish()

func get_server_params(message: String) -> Dictionary:
	var first: int = 2
	var params: Array = message.split(',')
	return { "iterations": params[2].substr(first).to_int(),
		"salt": Marshalls.base64_to_raw(params[1].substr(first)),
		"nonce": params[0].substr(first) }

func set_auth_message(client: Dictionary, server: String) -> void: # initial client message, server challenge, client response without proof.
	stats.message.auth = client.first + ',' + server + ',' + client.final

func encryption(object: Dictionary) -> bool: # Specifies that this message contains a SASL challenge. SCRAM-SHA-256
	var message: Dictionary = { "server": get_first_server_message(), "client": {} }
	var server: Dictionary = get_server_params(message.server)

	message.client.final = "c=biws,r=" + server.nonce
	stats.salt.pbkdf2(stats.credit.word.to_utf8_buffer(), server)

	var crypto: Crypto = Crypto.new()
	var client: Dictionary = { "key": stats.salt.hmac(crypto, stats.salt.output, stats.key("Client")) }
	var stored_key = get_stored_key(client.key)
	
	message.client.first = stats.message.client_safe()
	set_auth_message(message.client, message.server)

	client.signature = stats.salt.hmac(crypto, stored_key, stats.auth.to_utf8_buffer())
	
	var client_proof_buffer: PackedByteArray = get_proof(client)
	var client_proof := Marshalls.raw_to_base64(client_proof_buffer)
	message.client.final += ",p=" + client_proof
	
	var authentication_sasl_continue := op.request('p', message.client.final.to_ascii_buffer())

	peers.by_connection().put_data(authentication_sasl_continue)
