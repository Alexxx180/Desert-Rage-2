extends RefCounted

class_name AuthGetProof

signal stop()

var stats: SaslAuthenticationStats

func _compare_server_proof(server: Dictionary) -> bool: # If same, the client has proof about server access to server key.
	var message: String = stats.get_server_message()
	stats.get_proof(server) # 
	var proof: String = Marshalls.raw_to_base64(server.signature)
	var final: String = message.substr(SaslChallengeParameters.QUERY_SKIP)
	return final != proof # server.signature

func _get_server_side(type: HashingContext.HashType, salted_pass: PackedByteArray) -> Dictionary:
	var crypto: Crypto = Crypto.new()
	var key: PackedByteArray = crypto.hmac_digest(type, salted_pass, stats.key("Server"))
	return { "key": key, "signature": crypto.hmac_digest(type, key, stats.auth_safe()) }

func verify_proof() -> void: # Complete auth - compare server key and signature to received from the server
	var server: Dictionary = _get_server_side(EncryptionSASL.HASH, stats.salt.output)
	stats.salt.clean()
	
	if _compare_server_proof(server):
		stats.backend.connection.note.end_response("sasl_auth_error") # /!\ "authentication_error" signal not properly implemented...
		stop.emit()
