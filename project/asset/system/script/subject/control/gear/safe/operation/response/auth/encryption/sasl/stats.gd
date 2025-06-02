extends RefCounted

class_name SaslAuthenticationStats

var backend: Dictionary
var salt: EncryptionSalt = EncryptionSalt.new()

var message: Dictionary = { "client": "", "auth": "" }

func get_server_message() -> String:
	return backend.responses.fragments.word(9).get_string_from_ascii()

func put_ssl_initial(response: PackedByteArray) -> void: # A 0 byte is required as terminator after the last authentication mechanism name.
	backend.connection.peers.stream.by("connection").put_data(response)
	backend.responses.resize(0)

func get_client_message_length() -> PackedByteArray:
	return backend.op.reverse(len(message.client), backend.op.put_u32)

func set_client_first_message(type: String, nonce: String) -> void:
	message.client = "%c,,n=%s,r=%s" % [type, "", nonce] # When SCRAM-SHA-256 is used in PostgreSQL, the server will ignore the user name that the client sends in the client-first-message. The user name that was already sent in the startup message is used instead.

func get_proof(side: Dictionary) -> PackedByteArray:
	var proof: PackedByteArray = PackedByteArray()
	for i in side.key.size(): proof.append(side.key[i] ^ side.signature[i])
	return proof

func key(type: String) -> PackedByteArray: return (type + " Key").to_ascii_buffer()

func request(length: PackedByteArray, prefix: PackedByteArray) -> PackedByteArray:
	var client: PackedByteArray = message.client.to_utf8_buffer()
	var data: PackedByteArray = prefix + backend.op.byte + length + client
	backend.responses.resize()
	return backend.op.requests.p(data)

func message_renew(caption: String, result: Variant) -> Variant:
	message[caption] = ""
	return result

func client_safe() -> String:
	return message_renew("client", message.client.substr(3))

func auth_safe() -> PackedByteArray:
	return message_renew("auth", message.auth.to_utf8_buffer())
