extends RefCounted

class_name SaslAuthenticationStats

var peers: TransferPeers
var op: BufferOperations
var credit: EncryptionCredentials
var note: PostgreClientNotify

var message: Dictionary = { "client": "", "auth": "" }

func get_client_message_length() -> PackedByteArray:
	return op.reverse(len(client), op.put_u32)

func set_client_first_message(type, nonce) -> void:
	message.client = "%c,,n=%s,r=%s" % [type, "", nonce] # When SCRAM-SHA-256 is used in PostgreSQL, the server will ignore the user name that the client sends in the client-first-message. The user name that was already sent in the startup message is used instead.

func get_proof(side: Dictionary) -> PackedByteArray:
	var proof: PackedByteArray = op.empty
	for i in side.key.size(): proof.append(side.key[i] ^ side.signature[i])
	return proof

func key(type: String) -> PackedByteArray: return (type + " Key").to_ascii_buffer()

func request(responses: BackendResponses, length: PackedByteArray, prefix: PackedByteArray) -> PackedByteArray:
	return op.p(responses, prefix + op.byte + length + message.client.to_utf8_buffer())

func client_safe() -> String:
	var result: String = message.client.substr(3)
	message.client = ""
	return result

func auth_safe() -> PackedByteArray:
	var result: PackedByteArray = message.auth.to_utf8_buffer()
	message.auth = ""
	return result
