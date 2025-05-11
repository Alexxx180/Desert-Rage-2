extends RefCounted

class_name AuthMechanismDetermination

signal stop()

var _stop: bool = false

var stats: SaslAuthenticationStats

func scram_sha_256(object: Dictionary, type: String = 'n', suffix: String = ""): # SASL. Also used for GSSAPI, SSPI, not implemented...
	var crypto := Crypto.new() # The exact message type is deduced from the context.
	var nonce = Marshalls.raw_to_base64(crypto.generate_random_bytes(24))

	stats.set_client_first_message(type, nonce)

	var length: PackedByteArray = stats.get_client_message_length(op)
	var prefix: PackedByteArray = ("SCRAM-SHA-256" + suffix).to_ascii_buffer()

	stats.put_ssl_inital(stats.request(object.responses, length, prefix))

func scram_sha_256_plus(object: Dictionary) -> void: # Not done implementing SCRAM-SHA-256-PLUS
	_stop = false
	if _stop: scram_sha_256(object, 'y', '-PLUS') # /!\ Not end /!\

func no_implementation(name: String): print("No implementation: " + name)

func require_auth(object: Dictionary) -> void: # Get the message body is a list of SASL authentication mechanisms, in the server's order of preference.
	_stop = true
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
