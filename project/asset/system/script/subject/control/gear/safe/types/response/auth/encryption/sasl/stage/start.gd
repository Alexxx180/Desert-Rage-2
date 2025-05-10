extends RefCounted

class_name AuthMechanismDetermination

var stats: SaslAuthenticationStats

func put_ssl_initial(response: PackedByteArray) -> void:
	stats.peers.by_connection().put_data(response) # responses.resize(0)

func scram_sha_256(object: Dictionary, type: String = 'n', suffix: String = ""): # SASL. Also used for GSSAPI, SSPI and not implemented messages.
	var crypto := Crypto.new() # The exact message type is deduced from the context.
	var nonce = Marshalls.raw_to_base64(crypto.generate_random_bytes(24))

	stats.set_client_first_message(type, nonce)

	var length: PackedByteArray = stats.get_client_message_length(op)
	var prefix: PackedByteArray = ("SCRAM-SHA-256" + suffix).to_ascii_buffer()

	put_ssl_inital(stats.request(object.responses, length, prefix))

func scram_sha_256_plus(object: Dictionary) -> void: # Not done implementing SCRAM-SHA-256-PLUS
	_stop = false
	if _stop: scram_sha_256(object, 'y', '-PLUS') # /!\ Not end /!\

func no_implementation(name: String): print("No implementation: " + name)

func encryption(object: Dictionary) -> void:# Specifies that SASL authentication is required.
	_stop = true # Get the message body is a list of SASL authentication mechanisms, in the server's order of preference. A zero byte is required as terminator after the last authentication mechanism name. For each mechanism, there is the following:
	for mechanism in responses.split_byte(9, 0):
		var name: String = mechanism.get_string_from_ascii()
		match name:
			"SCRAM-SHA-256": scram_sha_256(object)
			"SCRAM-SHA-256-PLUS": scram_sha_256_plus(object)
			"SCRAM-SHA-1": no_implementation(name)
			"SCRAM-SHA-1-PLUS": no_implementation(name)
			"CRAM-MD5": no_implementation(name)
			"CRAM-MD5-PLUS": no_implementation(name)
	if _stop:
		object.note.end_response(responses, "no_sasl")
		stop.emit()
