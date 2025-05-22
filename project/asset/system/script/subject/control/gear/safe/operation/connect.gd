extends RefCounted

class_name PostgresHostConnect

signal change_security(method: int)

enum { USER = 1, WORD = 2, HOST = 3, PORT = 4, DB = 5 }

const URL: String = "^(?:postgresql|postgres)://(.+):(.+)@(.+):(\\d*)/(.+)"

var backend: Dictionary

func _process_url_string(url: String) -> RegExMatch:
	var regex = RegEx.new() #- https://www.postgresql.org/docs/current/libpq-connect.html#LIBPQ-CONNSTRING
	regex.compile(URL)
	return regex.search(url) #'port=5432 dbname=test_database user=tester password=test_password';

func _set_main_connect(host: String) -> void: # "postgres" is the database and user by default.
	var peers: TransferPeers = backend.connection.peers
	if peers.connected():
		peers.by_stream().put_data(backend.op.startup)
	elif not backend.connection.present():
		backend.connection.client.attempt(host)

func to_host(url: String, method: int, _timeout: int = 30) -> int:
	## Connect to PostgreSQL backend at specified url.
	var connection: ConnectionMetadata = backend.connection
	backend.credit.url = url
	change_security.emit(method)
	connection.state.code = 1

	if connection.status.present():
		connection.note.ask_for_closure(false)

	var result: RegExMatch = _process_url_string(url)
	if not result:
		connection.fail("no_url")
		return connection.status.code

	var text: Array = result.strings
	backend.op.startup_message(text[USER], text[DB])
	backend.credit.set_data(text[USER], text[WORD])
	connection.client.decide_port(text[PORT])
	#_set_main_connect(text[HOST])
	connection.client.attempt(text[HOST])
	
	if not connection.first_message():
		connection.note.fail("no_host")
	return connection.state.code
