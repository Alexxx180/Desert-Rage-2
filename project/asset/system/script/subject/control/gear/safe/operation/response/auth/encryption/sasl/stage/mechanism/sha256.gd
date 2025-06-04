extends RefCounted

class_name MechanismSHA256

signal stop()

const RANDOM: int = 24

var stats: SaslAuthenticationStats

func _set_client_message(type: String) -> void:
	var crypto: Crypto = Crypto.new() # The exact message type is deduced from the context.
	var nonce: String = Marshalls.raw_to_base64(crypto.generate_random_bytes(RANDOM))
	stats.set_client_first_message(type, nonce)

func _put_ssl_initial_request(suffix: String) -> void:
	var length: PackedByteArray = stats.get_client_message_length()
	var prefix: PackedByteArray = ("SCRAM-SHA-256" + suffix).to_ascii_buffer()
	stats.put_ssl_initial(stats.request(length, prefix))

func scram(type: String = 'n', suffix: String = ""): # SASL. Also used for GSSAPI, SSPI, not implemented...
	_set_client_message(type)
	_put_ssl_initial_request(suffix)
	stop.emit()

func scram_plus() -> void: # Not done implementing SCRAM-SHA-256-PLUS
	pass # scram_sha_256('y', '-PLUS')
