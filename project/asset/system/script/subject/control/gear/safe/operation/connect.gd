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
	elif not backend.connection.status.present():
		backend.connection.client.attempt(host)

func to_host(config: Dictionary, _timeout: int = 30) -> int: ## Connect Postgres with url.
	var connection: ConnectionMetadata = backend.connection
	var client: ConnectionClient = connection.client
	backend.credit.url = config.url
	change_security.emit(config.secure)
	client.reset()

	if connection.status.present():
		connection.note.ask_for_closure(false)

	var result: RegExMatch = _process_url_string(config.url)
	if not result:
		connection.fail("no_url")
		return connection.status.state

	var text: Array = result.strings
	backend.op.startup_message(text[USER], text[DB])
	backend.credit.set_data(text[USER], text[WORD])
	client.decide_port(text[PORT])
	#_set_main_connect(text[HOST])
	client.attempt(text[HOST])
	#backend.connection.peers.stream.peer.connect_to_host(text[HOST], client.port)
	
	if not Transfer.define(client.first_message(), connection.meta.set_etape):
		connection.note.fail("no_host")
	return connection.client.state
