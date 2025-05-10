extends RefCounted

class_name 

var stats: SaslAuthenticationStats

func compare_server_proof(server: Dictionary) -> bool: # Get server proof response
	var proof: PackedByteArray = stats.get_proof(server)
	var final: String = responses.slice_word(9).get_string_from_ascii()
	return final.substr(2) != Marshalls.raw_to_base64(proof) # server.signature)

func encryption_end(object: Dictionary) -> bool: # Specifies that SASL authentication has completed.
	var crypto: Crypto = Crypto.new() # The client verifies the proof from the server by calculating the ServerKey and the ServerSignature, then comparing its ServerSignature to that received from the server. If they are the same, the client has proof that the server has access to the ServerKey.
	var server: Dictionary = { "key": stats.salt.hmac(crypto, stats.salt.output_safe(), stats.key("Server")) }
	server.signature: PackedByteArray = stats.salt.hmac(crypto, server.key, stats.auth_safe())
	
	if compare_server_proof(server):
		object.note.end_response("sasl_auth_error") # /!\ "authentication_error" signal not properly implemented...
		stop.emit()
