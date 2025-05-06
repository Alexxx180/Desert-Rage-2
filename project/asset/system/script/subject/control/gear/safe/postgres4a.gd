extends RefCounted
# License MIT. Written by Samuel MARZIN. Edit by Tatarintsev Aleksandr. Detailed documentation: https://github.com/Marzin-bot/PostgreSQLClient/wiki/Documentation

## Godot PostgreSQL Client - GDscript script/class allowing to connect and run SQL commands with Postgres backend. Able to send and receive data from the backend. Useful for managing multiplayer game, by saving a large amount of data on a dedicated Postgres server. Written in pure GDScript to not depend on GDNative for portability reasons.
class_name PostgreSQLClient

## Version number (minor.major) of the PostgreSQL protocol used when connecting to the backend.
const PROTOCOL_VERSION := 3.0

## Default values throughout the script
const DEFAULT_INT: int = -1
const DEFAULT_DICT: Dictionary = {}
const 

## Backend runtime parameters. Information about server state. Secure dictionary to being empty if frontend is disconnected from the backend - updates once connection is established.
var parameter_status := {}

enum Status { DISCONNECTED, CONNECTING, CONNECTED, ERROR } ## Connection presentation

# The status of the connection.
var status = Status.DISCONNECTED

## Secure connection methods: insecure, SSL/TLS, GSSAPI
enum SecureConnectionMethod { NONE, SSL, GSSAPI }

var secure_connection_method_buffer: SecureConnectionMethod = SecureConnectionMethod.NONE

enum TransactionStatus { ## One or more queries [Q] transaction state.
	NOT_IN_A_TRANSACTION_BLOCK, ## [Q] not in a transaction.
	IN_A_TRANSACTION_BLOCK, ## [Q] in a transaction.
	IN_A_FAILED_TRANSACTION_BLOCK ## [Q] in error transaction.
}

var password_global: String
var user_global: String

var client := StreamPeerTCP.new()
var peerstream := PacketPeerStream.new()
var stream_peer_tls := StreamPeerTLS.new()
var peer: StreamPeer

var types: Dictionary = {
	"add": PostgreSQLClientAddType.new()
}

func _init():
	peerstream.set_stream_peer(client)
	peer = peerstream.stream_peer

const PORT: int = 5432 # Default PostgreSQL port

# To avoid confusion, codes below mustn't be the same as any protocol version number. Values contains significant pair of 16 bits: 1234 the most;
enum {
	CANCEL = 80877102 # The cancel request code. 5678 the least
	SSL = 80877103 # The SSL request code. 5679 the least.
	GSSAPI = 80877104 # The GSSAPI Encryption request code. 5680 the least
}

## Fires when backend connection closes. If closed correctly "was_clean_close" is true otherwise false.
signal connection_closed(was_clean_close)
signal connection_error() # del /!\ # No use

## Triggered when authentication process failed during contact with the target backend. Dictionary that contains various information with the error nature.
signal authentication_error(error_object)

## Triggered when frontend and backend connection is established. Good time to start making requests to the backend with "execute".
signal connection_established()

## Returns an Array of PostgreSQLQueryResult. May be empty. There are as many PostgreSQLQueryResult elements in the array as there are SQL statements in sql - except in exceptional cases.
signal data_received(error_object, transaction_status, datas)

################ No use at
var process_backend_id: int ## The process ID of this backend.
var process_backend_secret_key: int ## The secret key of this backend.
################ the moment

var status_ssl = 0

var global_url = ""
var startup_message: PackedByteArray
var next_etape := false

var pclient: String:
	get: return get_pclient()

func get_pclient() -> String: return "[PostgreSQLClient:%d]" % get_instance_id()
func byte() -> PackedByteArray: return PackedByteArray([0])

func to_utf8(result, no: int): return result.strings[no].to_utf8_buffer()
func to_float(result, no: int): return result.strings[no].to_float()
func ascii(source: String): return source.to_ascii_buffer()

func x_request() -> return request('X', PackedByteArray())

# Secure dictionary to being empty if no backend connection.
func safe_dictionary() -> Dictionary: return {}

# https://www.postgresql.org/docs/current/libpq-connect.html#LIBPQ-CONNSTRING
func _process_url_string(url: String):
	var regex = RegEx.new()
	regex.compile("^(?:postgresql|postgres)://(.+):(.+)@(.+):(\\d*)/(.+)")
	return regex.search(url)
	#'port=5432 dbname=test_database user=tester password=test_password';

func decide_port(port: String) -> int:
	return port.to_int() if port else PORT

## Allows you to connect to a Postgresql backend at the specified url.
func connect_to_host(url: String, method: SecureConnectionMethod = SecureConnectionMethod.NONE, _connect_timeout := 30) -> int:
	global_url = url
	secure_connection_method_buffer = method# secure_connection_method
	var error := 1
	
	if status == Status.CONNECTED: close(false) # Disconnect if already connected.

	var result = _process_url_string(url)
	if result: ### StartupMessage ### "postgres" is the database and user by default.
		startup_message = request("", ascii("user") + byte() + to_utf8(result, 1) + byte() + ascii("database") + byte() + to_utf8(result, 5) + PackedByteArray([0, 0]))
		
		password_global = result.strings[2]
		user_global = result.strings[1]
		var port: int = decide_port(result.strings[4])
		
		""" main
		if stream_peer_ssl.get_status() == stream_peer_ssl.STATUS_CONNECTED:
			stream_peer_ssl.put_data(startup_message)
		else:
			if not client.is_connected_to_host() and client.get_status() == StreamPeerTCP.STATUS_NONE:
				error = client.connect_to_host(result.strings[3], port)
		"""
		if client.get_status() == StreamPeerTCP.STATUS_NONE:
			error = client.connect_to_host(result.strings[3], port)
		
		if error == OK: # Get the fist message of server.
			next_etape = true
		else:
			push_error(pclient + "Invalid host Postgres.")
	else:
		status = Status.ERROR
		push_error(pclient + "Invalid Postgres URL.")
	
	return error


## Dictionary with execution information of the last requests made on the backend. If it's empty - backend didn't detect any error in the query. Should be used right after "execute" method. Secure dictionary to being empty if frontend is disconnected from the backend.
var error_object := {}
var busy := false



func client_active(client) -> bool:
	return client.is_connected_to_host() and client.get_status() == StreamPeerTCP.STATUS_CONNECTED

func is_connected(stream_peer_tls) -> bool:
	return stream_peer_tls.get_status() == stream_peer_tls.STATUS_CONNECTED

func handshaking(stream_peer_tls) -> bool:
	var _status = stream_peer_tls.get_status()
	return _status == stream_peer_tls.STATUS_HANDSHAKING and _status = stream_peer_tls.STATUS_CONNECTED

func determine_data(stream_peer_tls, result) -> void:
	if is_connected(stream_peer_tls):
		stream_peer_tls.put_data(result)
	else:
		peer.put_data(result)

## Send SQL query to run on the backend. "sql" contains one or more valid SQL statements.
func execute(sql: String) -> Variant:
	if status == Status.CONNECTED:
		if not busy: # alpha
			var request_result := request('Q', sql.to_utf8_buffer() + byte())
			
			determine_data(stream_peer_tls, request_result)
			busy = true
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
					push_warning(pclient + " Backend didn't send any data / a problem encountered while the backend sent a response to the request.")
			return [] if result == null else result
			#return OK
			#return ERR_BUSY
	else:
		push_error(pclient + " No connection to backend.")
	return []
	#return ERR_CONNECTION_ERROR

func no_connection() -> void:
	push_error(pclient + " The frontend is not connected to backend.")

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

# Upgrade the connection to SSL.
func set_ssl_connection() -> void:
	if handshaking(stream_peer_tls):
		push_warning(pclient + " The connection is already secured with TLS/SSL.")
	else:
		set_connection(client, SSL) ### SSLRequest ###

##### No use ##### Upgrade the connection to GSSAPI.
func set_gssapi_connection() -> void:
	set_connection(client, GSSAPI) ### GSSENCRequest ###

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

func parse_version(buffer) -> void:# Version parsing
	var zeros: int = 2
	var major = int(PROTOCOL_VERSION)
	var minor = major - PROTOCOL_VERSION
	for char_number in str(major).pad_zeros(zeros) + str(minor).pad_zeros(zeros):
		buffer.put_data(PackedByteArray([char_number.to_int()]))

func request(type_message: String, message := PackedByteArray()) -> PackedByteArray:
	# Get the size of message.
	var buffer := StreamPeerBuffer.new()
	var message_length := _get_reversed(buffer, func(b): b.put_u32(message.size() + (4 if type_message else 8)))
	
	# If the message is not StartupMessage...
	if type_message: buffer.put_8(type_message.unicode_at(0))
	
	buffer.put_data(message_length)
	
	# If the message is StartupMessage...
	if type_message.is_empty(): parse_version(buffer)
	
	buffer.put_data(message)
	error_object = {}
	
	return buffer.data_array.slice(4)

func _get_reversed(buffer, method: Callable) -> PackedByteArray:
	method.call(buffer)
	var bytes := buffer.data_array
	bytes.reverse()
	return bytes

func get_32ubyte_reverse(value: iny) -> void:
	return _get_reversed(StreamPeerBuffer.new(), func(b): b.put_u32(value))

func get_32byte_reverse(value: int) -> PackedByteArray:
	return _get_reversed(StreamPeerBuffer.new(), func(b): b.put_32(value))

func split_pool_byte_array(pool_byte_array: PackedByteArray, delimiter: int) -> Array:
	var array := []
	var from := 0
	var to := 0
	
	for byte in pool_byte_array:
		if byte == delimiter:
			array.append(pool_byte_array.slice(from, to + 1))
			from = to + 1
		
		to += 1
		
	return array


func pbkdf2(hash_type: int, password: PackedByteArray, salt: PackedByteArray, iterations := 4096, length := 0) -> PackedByteArray:
	const END = 0xFF
	var crypto := Crypto.new()
	var hash_length := len(crypto.hmac_digest(hash_type, salt, password))

	if length == 0: length = hash_length
	
	var output := PackedByteArray()
	var block_count: int = ceil(length / float(hash_length))
	
	var buffer := PackedByteArray()
	buffer.resize(4)
	
	for block in block_count:
		for i in 3:
			buffer[i] = (int(block + 1) >> (24 - 8 * i)) & END
		buffer[3] = int(block + 1) & END
		
		var key_1 := crypto.hmac_digest(hash_type, password, salt + buffer)
		var key_2 := key_1
		
		for _index in iterations - 1:
			key_1 = crypto.hmac_digest(hash_type, password, key_1)
			
			for index in key_1.size():
				key_2[index] ^= key_1[index]
		
		output += key_2
	
	return output.slice(0, hash_length)

var postgresql_query_result_instance: PostgreSQLQueryResult = PostgreSQLQueryResult.new()

var datas_command_sql := []

var response_buffer: PackedByteArray

# Authentication SASL
var client_first_message: String 
var salted_password: PackedByteArray
var auth_message: String

func _match_response(data, value, field, keys: Dictionary, feedback: Dictionary) -> void:
	if feedback.has(field):
		feedback[field].call()
	elif keys.has(field):
		data[keys[field]] = value
	# More field types might be added in future - unrecognized should be silently ignored.

func _get_match_fields() -> Dictionary:
	return {
		'V': "severity_no_localized",
		'C': "SQLSTATE_code",
		'D': "detail",
		'H': "hint",
		'P': "position",
		'p': "internal_position",
		'q': "internal_query",
		'W': "where",
		's': "schema_name",
		't': "table_name",
		'c': "column_name",
		'd': "constraint_name",
		'n': "constraint_name",
		'F': "file",
		'L': "line",
		'R': "routine"
	}

func _add_data(buffer, data, seek: int = -1) -> void:
	buffer.put_data(data)
	if seek == -1:
		buffer.seek()
	else:
		buffer.seek(seek)

func _reverse_response(buffer, response, seek: int = 0):
	resonse.reverse()
	_add_data(buffer, response, seek)
	return response

# Get the format codes to be used for each column.
# Each must presently be zero (text) or one (binary). All must be zero if the overall copy format is textual.
func format_column_codes(buffer, response, columns) -> void:
	for index in columns:
		var format_code = _reverse_response(buffer, response.slice(10, 13), 2 * index + 3)
		format_code = buffer.get_16()
		print(format_code) # The result.

func copy_type_response(buffer, response, type: String) -> void:
	### CopyResponse ### The message "CopyResponse" identifies the message as a Start Copy response. This message will be followed by copy data.
	
	buffer = StreamPeerBuffer.new()
	# Get overall copy format code. 0 indicates the overall COPY format is text (rows separated by newlines, columns separated by separator characters, etc). 1 indicates the overall copy format is binary (similar to DataRow format). See COPY for more information.
	var overall_copy_format_code = _reverse_response(buffer, response.slice(5, 7), 0)
	overall_copy_format_code = buffer.get_8()
	# Get the number of columns in the data to be copied.
	var number_of_columns = _reverse_response(buffer, response.slice(7, 10), 1)
	number_of_columns = buffer.get_16()
	format_column_codes(buffer, response_buffer, number_of_columns)
	
	push_warning(pclient + " Copy" + type + "Response, no support.")


