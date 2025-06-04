extends RefCounted

class_name SaslChallenge

var params: SaslChallengeParameters = SaslChallengeParameters.new()

func _set_auth_message(client: Dictionary, server: String) -> void: # initial client message, server challenge, client response without proof.
	client.first = params.stats.client_safe()
	params.stats.message.auth = client.first + ',' + server + ',' + client.final

func _salt_password(message: Dictionary) -> void:
	var server: Dictionary = params.get_server(message.first)
	message.client.final = "c=biws,r=" + server.nonce
	params.stats.salt.pbkdf2(params.word, server)

func _get_final_client(message: Dictionary) -> String:
	var client: Dictionary = params.get_client_side(EncryptionSASL.HASH, params.stats.salt.output)
	message.client.proof = Marshalls.raw_to_base64(params.stats.get_proof(client))
	return message.client.final + ",p=" + message.client.proof

func _get_message() -> String:
	var message: Dictionary = { "first": params.stats.get_server_message(), "client": {} }
	_salt_password(message)
	_set_auth_message(message.client, message.first)
	return _get_final_client(message)

func encryption() -> void: # Specifies that this message contains a SASL challenge. SCRAM-SHA-256
	var final: String = _get_message()
	#print("CLIENT FINAL MESSAGE: ", final)
	var auth: PackedByteArray = params.stats.backend.op.requests.p(final.to_ascii_buffer())
	params.stats.put_ssl_initial(auth)
