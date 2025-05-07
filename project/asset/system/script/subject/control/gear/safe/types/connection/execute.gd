extends RefCounted

class_name ExecutePostgreRequest

var note: PostgreClientNotify
var credit: EncryptionCredentials
var op: BufferOperations

var _status: ConnectionMetadata

func decide_port(port: String) -> int:
	return port.to_int() if port else PORT

# https://www.postgresql.org/docs/current/libpq-connect.html#LIBPQ-CONNSTRING
func _process_url_string(url: String):
	var regex = RegEx.new()
	regex.compile("^(?:postgresql|postgres)://(.+):(.+)@(.+):(\\d*)/(.+)")
	return regex.search(url)
	#'port=5432 dbname=test_database user=tester password=test_password';

func _set_main_connect(result) -> void:
	if stream_peer_ssl.get_status() == stream_peer_ssl.STATUS_CONNECTED:
		stream_peer_ssl.put_data(op.startup_message)
	elif not client.is_connected_to_host() and client.get_status() == StreamPeerTCP.STATUS_NONE:
		error = client.connect_to_host(result.strings[3], port)

## Allows you to connect to a Postgresql backend at the specified url.
func connect_to_host(url: String, method: SecureConnectionMethod = SecureConnectionMethod.NONE, _connect_timeout := 30) -> int:
	credit.url = url
	secure_connection_method_buffer = method# secure_connection_method
	var error := 1
	
	if status == Status.CONNECTED: close(false) # Disconnect if already connected.

	var result = _process_url_string(url)
	if result: # "postgres" is the database and user by default.
		op.startup_message(result.strings)

		credit.set_data(result.strings)
		var port: int = decide_port(result.strings[4])
		
		# _set_main_connect()
		if client.get_status() == StreamPeerTCP.STATUS_NONE:
			error = client.connect_to_host(result.strings[3], port)
		
		if error == OK: # Get the fist message of server.
			_status.next_etape = true
		else:
			note.fail("no_host")
	else:
		status = Status.ERROR
		note.fail("no_url")
	
	return error

func determine_data(stream_peer_tls, result) -> void:
	if is_connected(stream_peer_tls):
		stream_peer_tls.put_data(result)
	else:
		peer.put_data(result)

func client_connected() -> bool:
	return client.get_status() == StreamPeerTCP.STATUS_CONNECTED

func client_active(client) -> bool:
	return client.is_connected_to_host() and client_connected(client)

## Send SQL query to run on the backend. "sql" contains one or more valid SQL statements.
func execute(sql: String) -> Variant:
	if status == Status.CONNECTED:
		if not _status.busy: # alpha
			var request_result := credit.request('Q', sql.to_utf8_buffer() + byte())
			
			determine_data(stream_peer_tls, request_result)
			_status.busy = true
			determine_data(stream_peer_tls, request_result)

			var result = null
			
			while client_active(client) and status == Status.CONNECTED and result == null:
				var response := [OK, byte()]
				
				if is_connected(stream_peer_tls):
					stream_peer_tls.poll()
					var available = stream_peer_tls.get_available_bytes()
					if available:
						response = stream_peer_tls.get_data(available) # I don't know why it crashes when this value (stream_peer_ssl.get_available_bytes()) is equal to 0 so I pass it a condition. It is probably a Godot bug.
					else:
						continue
				else:
					response = peer.get_data(peer.get_available_bytes())
				
				if response[0] == OK:
					result = response_parser(response[1])
				else:
					note.warn("no_data")
			return [] if result == null else result
			#return OK
			#return ERR_BUSY
	else:
		note.fail("no_connection")
	return []
	#return ERR_CONNECTION_ERROR
