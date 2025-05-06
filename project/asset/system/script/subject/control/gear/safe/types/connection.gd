extends RefCounted

var status_ssl: bool = false

func ssl_deconnection(clean: bool) -> void:
	if clean:
		stream_peer_tls.put_data(x_request())
	stream_peer_tls.disconnect_from_stream()

func client_disconnect(clean: bool) -> void:
	if clean:
		peer.put_data(x_request())
	client.disconnect_from_host()

func _set_bad_connection_status(message: String) -> void:
	status = Status.ERROR
	push_error(pclient + message)
	close(false)

## Close the connection with the backend. If "clean_closure" is true, the frontend will notify backend about request to close the connection. Otherwise, the frontend closes the connection without notifying the backend. Not recommended. Has no effect if no connection present.
func close(clean_closure := true) -> void:
	if status == Status.CONNECTED:
		### Terminate ### Identifies the message as a termination.
		if handshaking(stream_peer_tls): # SSL Deconnection
			ssl_deconnection(clean_closure)
		else:
			client_disconnect(clean_closure)
		
		parameter_status = safe_dictionary()
		error_object = safe_dictionary()
		
		status = Status.DISCONNECTED
		status_ssl = 0
		next_etape = false
		busy = false # alpha
		
		emit_signal("connection_closed", clean_closure)
	else:
		push_warning(pclient + " The frontend was already disconnected from the backend when calling 'close'.")

func set_crypto() -> void:
	#var crypto = Crypto.new()
	#var ssl_key = crypto.generate_rsa(4096)
	#var ssl_cert = crypto.generate_self_signed_certificate(ssl_key)
	stream_peer_tls.connect_to_stream(peer, "")
	# stream_peer_tls.blocking_handshake = false
	status_ssl = 2

func _get_storage():
	return peer if status_ssl == 0 else stream_peer_tls

func check_response(response, storage) -> void:
	var text = response[1]
	if response[0] == OK and text.size():
		var servire = reponce_parser(text)
		if servire: storage.put_data(servire)

## Poll the connection to check for incoming messages. Should be called before "execute" for it to work properly and called frequently in a loop.
func poll() -> void:
	client.poll()
	
	if client.get_status() == StreamPeerTCP.STATUS_CONNECTED:
		if handshaking(stream_peer_tls):
			stream_peer_tls.poll()
		
		if next_etape:
			if secure_connection_method_buffer == SecureConnectionMethod.SSL:
				set_ssl_connection() ### SSLRequest ###
			else:
				peer.put_data(startup_message)
				startup_message = PackedByteArray()
			
			next_etape = false
		
		if status_ssl == 1:
			var response = peer.get_data(peer.get_available_bytes())
			var _status: int = response[0]
			if _status == OK:
				var state = response[1]
				if not state.is_empty():
					var value = char(state[0])
					match value:
						'S': set_crypto()
						'N': _set_bad_connection_status(" The connection attempt failed. The backend doesn't want to establish a secure SSL/TLS connection.")
						_:
							_set_bad_connection_status(" The backend sent an unknown response to the request to establish a secure connection. Response is not recognized: '%c'." % value)
			else:
				push_warning(pclient + " The backend did not send any data or there must have been a problem while the backend sent a response to the request.")
		
		if status == Status.CONNECTED and busy:
			var response: Array = [OK, PackedByteArray()]
			
			if stream_peer_tls.get_status() == stream_peer_tls.CONNECTED:
				if stream_peer_tls.get_available_bytes():
					response = stream_peer_tls.get_data(stream_peer_tls.get_available_bytes()) # I don't know why it crashes when this value (stream_peer_tls.get_available_bytes()) is equal to 0 so I pass it a condition. It is probably a Godot bug.
			else:
				response = peer.get_data(peer.get_available_bytes())
			
			if response[0] == OK:
				reponce_parser(response[1])
			else:
				push_warning(pclient + " The backend did not send any data or there must have been a problem while the backend sent a response to the request.")
		
		
		if status_ssl == 2 and stream_peer_tls.get_status() == stream_peer_tls.CONNECTED:
			stream_peer_tls.put_data(startup_message)
			status_ssl = 3
		
		if status_ssl != 1 and status_ssl != 2 and not status == Status.CONNECTED:
			var storage = _get_storage()
			var reponce: Array = storage.get_data(storage.get_available_bytes())
			check_response(reponce, storage)
