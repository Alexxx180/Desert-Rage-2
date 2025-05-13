extends RefCounted

class_name AuthGetProof

signal stop()

var stats: SaslAuthenticationStats

func _compare_server_proof(server: Dictionary) -> bool: # If same, the client has proof about server access to server key.
	var proof: PackedByteArray = stats.get_proof(server)
	var final: String = stats.get_server_message()
	return final.substr(2) != Marshalls.raw_to_base64(proof) # server.signature

func verify_proof() -> void: # Complete auth - compare server key and signature to received from the server
	var crypto: Crypto = Crypto.new() #
	var server: Dictionary = { "key": stats.salt.hmac(crypto, stats.salt.output_safe(), stats.key("Server")) }
	server.signature = stats.salt.hmac(crypto, server.key, stats.auth_safe())
	
	if _compare_server_proof(server):
		stats.connection.note.end_response("sasl_auth_error") # /!\ "authentication_error" signal not properly implemented...
		stop.emit()
