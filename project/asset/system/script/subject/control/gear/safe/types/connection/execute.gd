extends RefCounted

class_name ExecutePostgreRequest

const PROTOCOL: String = "tls"

var note: PostgreClientNotify
var credit: EncryptionCredentials
var op: BufferOperations
var peers: TransferPeers

var _connection: ConnectionMetadata

func decide_port(port: String) -> int:
	return port.to_int() if port else PORT

# https://www.postgresql.org/docs/current/libpq-connect.html#LIBPQ-CONNSTRING
func _process_url_string(url: String):
	var regex = RegEx.new()
	regex.compile("^(?:postgresql|postgres)://(.+):(.+)@(.+):(\\d*)/(.+)")
	return regex.search(url)
	#'port=5432 dbname=test_database user=tester password=test_password';

func _set_main_connect(result) -> void:
	if peers.connected("ssl"): peers.stream.ssl.put_data(op.startup)
	elif not _connection.present(): _connection.attempt(result)

## Allows you to connect to a Postgresql backend at the specified url.
func connect_to_host(url: String, method: SecureConnectionMethod, _connect_timeout := 30) -> int:
	credit.url = url
	secure_connection_method_buffer = method# secure_connection_method
	var error := 1
	
	if _connection.present(): note.set_close(false) # Disconnect if already connected.

	var result = _process_url_string(url)
	if result: # "postgres" is the database and user by default.
		var text: Array = result.strings
		op.startup_message(text)
		credit.set_data(text)
		_connection.decide_port(text[4])# _set_main_connect()
		_connection.attempt(result)
		
		if not _connection.first_message(): note.fail("no_host")
	else:
		_connection.fail()
		note.fail("no_url")
	
	return error

func determine(result) -> void: peers.by_connection(PROTOCOL).put_data(request_result)

## Send SQL query to run on the backend. "sql" contains one or more valid SQL statements.
func execute(sql: String) -> Variant:
	if _connection.already_had():
		if not _connection.busy: # alpha
			var request_result := credit.request('Q', sql.to_utf8_buffer() + byte())

			determine(request_result)
			_connection.busy = true
			determine(request_result)

			var result = null
			
			while _connection.active() and result == null:
				var response := [OK, byte()]
				
				if peers.connected(PROTOCOL):
					var peer = peers.stream[PROTOCOL]
					peer.poll()
					var available = peer.get_available_bytes()
					if available:
						response = peers.get_data(available) # Crash value avoidance (stream_peer_ssl.get_available_bytes() == 0).
					else:
						continue
				else:
					response = peer.get_data(peer.get_available_bytes())
				
				if response[0] != OK: note.warn("no_data")
				else: result = response_parser(response[1])

			return [] if result == null else result
			#return OK
			#return ERR_BUSY
	else:
		note.fail("no_connection")
	return []
	#return ERR_CONNECTION_ERROR
