extends RefCounted

class_name PostgresHostConnect

signal change_security(method: int)

const URL: String = "^(?:postgresql|postgres)://(.+):(.+)@(.+):(\\d*)/(.+)"

var credit: EncryptionCredentials
var connection: ConnectionMetadata
var op: BufferOperations

func _process_url_string(url: String) -> RegExMatch:
	var regex = RegEx.new() #- https://www.postgresql.org/docs/current/libpq-connect.html#LIBPQ-CONNSTRING
	regex.compile(URL)
	return regex.search(url) #'port=5432 dbname=test_database user=tester password=test_password';

func _set_main_connect(result) -> void: # "postgres" is the database and user by default.
	if connection.peers.connected("ssl"): connection.peers.stream.ssl.put_data(op.startup)
	elif not connection.present(): connection.attempt(result)

## Allows you to connect to a PostgreSQL backend at the specified url.
func connect(url: String, method: int, timeout: int = 30) -> int:
	credit.url = url
	change_security.emit(method)
	connection.status.code = 1

	if connection.present(): connection.note.ask_for_closure(false)

	var result: RegExMatch = _process_url_string(url)
	if not result:
		connection.fail("no_url")
		return connection.status.code

	var text: Array = result.strings
	op.startup_message(text)
	credit.set_data(text)
	connection.decide_port(text[4]) # _set_main_connect()
	connection.attempt(result)
	
	if not connection.first_message(): connection.note.fail("no_host")
	return connection.status.code
