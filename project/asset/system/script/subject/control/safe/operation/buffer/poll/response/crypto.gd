extends RefCounted

class_name CryptoConnection

var connection: ConnectionMetadata

func set_crypto() -> void:
	print("OK")
	#var crypto = Crypto.new() ; var ssl_key = crypto.generate_rsa(4096) ; var ssl_cert = crypto.generate_self_signed_certificate(ssl_key)
	connection.peers.connect_to("") # stream_peer_tls.blocking_handshake = false
	connection.peers.stream.ssl.set_connecting()

func bad_status(message: String, postfix: String = "") -> void:
	print("FAILED: ", message)
	connection.fail(message, postfix)
	connection.note.ask_for_closure(false)

func determine(message: int) -> void:
	var type: String = char(message)
	print("TRY DETERMINE CONNECTION: ", type)
	match type:
		'S': set_crypto()
		'N': bad_status("ssl_fail")
		_: bad_status("ssl_unrecognized", type)

func update() -> void:
	var response: Array = connection.peers.get_response("")
	var _status: int = response[PollResponse.STATUS]
	var state: Array = response[PollResponse.VALUE]

	if _status == OK and not state.is_empty():
		determine(state[PollResponse.STATUS])
	else:
		connection.note.warn("no_data")
