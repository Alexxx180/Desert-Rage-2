extends RefCounted

class_name CryptoConnection

var connection: ConnectionMetadata

func set_crypto() -> void:
	#var crypto = Crypto.new() ; var ssl_key = crypto.generate_rsa(4096) ; var ssl_cert = crypto.generate_self_signed_certificate(ssl_key)
	connection.peers.connect("") # stream_peer_tls.blocking_handshake = false
	connection.state.ssl = 2

func bad_status(message: String, postfix: String = "") -> void:
	connection.fail(message, postfix)
	connection.note.ask_for_closure(false)

func update() -> void:
	if connection.state.ssl != 1: return

	var response: Array = connection.peers.get_response()
	var _status: int = response[PollResponse.STATUS]
	var state: Array = response[PollResponse.VALUE]

	if _status != OK or state.is_empty(): connection.note.warn("no_data"); return

	var message: int = state[PollResponse.STATUS]
	var type: String = str(message)
	match type:
		'S': set_crypto()
		'N': bad_status("ssl_fail")
		_: bad_status("ssl_unrecognized", value)
