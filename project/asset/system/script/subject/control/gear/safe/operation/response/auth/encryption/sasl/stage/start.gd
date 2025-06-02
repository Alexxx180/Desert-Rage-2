extends RefCounted

class_name AuthMechanismDetermination

enum { SPLIT = 9, RANDOM = 24 }

signal stop()

var _stop: bool = false
var stats: SaslAuthenticationStats

func scram_sha_256(type: String = 'n', suffix: String = ""): # SASL. Also used for GSSAPI, SSPI, not implemented...
	_stop = false
	var crypto: Crypto = Crypto.new() # The exact message type is deduced from the context.
	var nonce: String = Marshalls.raw_to_base64(crypto.generate_random_bytes(RANDOM))

	stats.set_client_first_message(type, nonce)

	var length: PackedByteArray = stats.get_client_message_length()
	var prefix: PackedByteArray = ("SCRAM-SHA-256" + suffix).to_ascii_buffer()

	stats.put_ssl_initial(stats.request(length, prefix))
	stop.emit()

func scram_sha_256_plus() -> void: # Not done implementing SCRAM-SHA-256-PLUS
	pass # scram_sha_256('y', '-PLUS')

func no_implementation(name: String): print("No implementation: " + name)

func require_auth() -> void: # Get the message body is a list of SASL authentication mechanisms, in the server's order of preference.
	_stop = true
	for mechanism in stats.backend.responses.fragments.bytes(SPLIT):
		var name: String = mechanism.get_string_from_ascii()
		match name:
			"SCRAM-SHA-256": scram_sha_256()
			"SCRAM-SHA-256-PLUS": scram_sha_256_plus()
			"SCRAM-SHA-1": no_implementation(name)
			"SCRAM-SHA-1-PLUS": no_implementation(name)
			"CRAM-MD5": no_implementation(name)
			"CRAM-MD5-PLUS": no_implementation(name)
	if _stop:
		stats.backend.connection.note.end_response("no_sasl")
		stop.emit()
