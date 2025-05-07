extends RefCounted

var status_ssl: bool = false
var peers: TransferPeers
var _connection: ConnectionMetadata

enum SecureConnectionMethod { NONE, SSL, GSSAPI } ## Secure: insecure, SSL/TLS, GSSAPI

enum { # Significant pair of 16 bits: 1234 the most;
	CANCEL = 80877102 # Cancel request code. 5678 the least
	SSL = 80877103 # SSL request code. 5679 the least.
	GSSAPI = 80877104 # GSSAPI Encryption code. 5680 the least
} # To avoid confusion codes aren't same as any protocol ver. number.

func x_request() -> return request('X', PackedByteArray())

func no_connection() -> void:
	push_error(pclient + " The frontend is not connected to backend.")

func ssl_deconnection(clean: bool) -> void:
	if clean:
		stream_peer_tls.put_data(x_request())
	stream_peer_tls.disconnect_from_stream()

func client_disconnect(clean: bool) -> void:
	if clean: peer.put_data(x_request())
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
	
		_connection.reset()
		status = Status.DISCONNECTED
		status_ssl = 0
		_connection.not_busy()
		
		connection_closed.emit()
	else:
		push_warning(pclient + " The frontend was already disconnected from the backend when calling 'close'.")

func set_crypto() -> void:
	#var crypto = Crypto.new()
	#var ssl_key = crypto.generate_rsa(4096)
	#var ssl_cert = crypto.generate_self_signed_certificate(ssl_key)
	stream_peer_tls.connect_to_stream(peer, "")
	# stream_peer_tls.blocking_handshake = false
	status_ssl = 2

func check_response(response, storage) -> void:
	var text = response[1]
	if response[0] == OK and text.size():
		var servire = reponce_parser(text)
		if servire: storage.put_data(servire)

func set_buffered_data(request: int, before: Callable, after: Callable) -> void:
	var buffer := StreamPeerBuffer.new()
	before.call(buffer)
	buffer.put_data(get_32byte_reverse(request))
	after.call(buffer)

func set_connection(client, request: int) -> void:
	if client.get_status() == StreamPeerTCP.STATUS_CONNECTED:
		set_buffered_data(request,
			func(b): b.put_data(get_32ubyte_reverse(8)), # Message length bytes with self.
			func(b): peer.put_data(b.data_array)
		)
	else:
		no_connection()

func set_ssl_connection() -> void: # Upgrade the connection to SSL.
	if handshaking(stream_peer_tls):
		push_warning(pclient + " Connection already secured with TLS/SSL.")
	else:
		set_connection(client, SSL) ### SSLRequest ###

func set_gssapi_connection() -> void: # No use. Upgrade the connection to GSSAPI.
	set_connection(client, GSSAPI) ### GSSENCRequest ###

func set_buffered_data(request: int, before: Callable, after: Callable) -> void:
	var buffer := StreamPeerBuffer.new()
	before.call(buffer)
	buffer.put_data(get_32byte_reverse(request))
	after.call(buffer)

func reverse_length(data) -> void:
	var message_length := data
	message_length.reverse()
	return message_length

## This function undoes all changes made to the database since the last Commit.
func rollback(process_id: int, process_key: int, _method: int = SecureConnectionMethod.NONE) -> void:
	if status != Status.CONNECTED: no_connection(); return
	### CancelRequest ###
	set_buffered_data(CANCEL,
	func(b):
		b.put_u32(16) # Message length bytes with self.
		b.put_data(reverse_length(b.data_array))
	func(b):
		b.put_u32(process_id) # The process ID of
		b.put_u32(process_key) # The secret key for
		peer.put_data(b.data_array.slice(4)) # ... the target backend
	)

## Poll the connection to check for incoming messages. Should be called before "execute" for it to work properly and called frequently in a loop.
func poll() -> void:
	client.poll()
	
	if client.get_status() == StreamPeerTCP.STATUS_CONNECTED:
		if handshaking(stream_peer_tls):
			stream_peer_tls.poll()
		
		if _status.next_etape:
			if secure_connection_method_buffer == SecureConnectionMethod.SSL:
				set_ssl_connection() ### SSLRequest ###
			else:
				peer.put_data(startup_message)
				startup_message = PackedByteArray()
			
			_connection.next_etape = false
		
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
		
		if status == Status.CONNECTED and _status.busy:
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
			var storage = peers.by_ssl(status_ssl)
			var reponce: Array = storage.get_data(storage.get_available_bytes())
			check_response(reponce, storage)
