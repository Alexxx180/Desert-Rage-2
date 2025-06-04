extends Node

const PREFIX: String = "postgresql://"

#@onready var database: Node = $client
var database: PostgreSQLClient = PostgreSQLClient.new()
var session: Dictionary = {
	"user": "postgres", "word": "l1F3tpI9geR", "port": 5432, "database": "postgres"
}

func _get_login() -> String:
	return session.user + ":" + session.word + "@" + session.host

func _get_connection_string() -> String:
	return str(_get_login(), ":", session.port, "/", session.database)

func new_session() -> void:
	session.host = "localhost"

func _ready() -> void:
	on_load_user_data()

func on_load_user_data() -> void:
	new_session()
	database.connect_signals(self)
	var config: Dictionary = {
		"url": "postgresql://postgres:l1F3tpI9geR@localhost:5432/postgres",
			#PREFIX + _get_connection_string(),
		#"secure": SecureDataBuffer.SSL
		"secure": SecureDataBuffer.CANCEL
	}
	if database.op.connection.to_host(config) == OK:
		#database.op.poll.poll()
		#database.op.connection.backend.connection.status.succeed()
		print("START CONNECTION")
		#connection_established()

func _physics_process(_delta: float) -> void:
	database.op.poll.poll()

func _create_query() -> String:
	return """
	BEGIN;
	CREATE TABLE hero (id UUID CONSTRAINT hero_pid PRIMARY KEY, name INTEGER, status JSON, inventory JSON);
	"""

func _insert_query() -> String:
	return """
	BEGIN;
	INSERT INTO hero (id, name, status, inventory) VALUES ('73ff36dc-8898-4b0e-b9b3-d1d769c87ede', 0, '{}', '{}')
	"""

func connection_established() -> void:
	print("HAVE CONNECTION")
	"""
	var query: String = _create_query()
	#var query: String = _insert_query()
	var status = database.op.execute.query(query)
	"""
	var status = database.op.execute.query("BEGIN; SELECT * FROM hero;")
	#"""
	print("STATUS: ", status)
	# for d in status: print(d)
	# var data = database.op.connection.backend.connection.peers.stream.by("connection")
	
	#"""
	#var peer = database.op.connection.backend.connection.peers.stream.peer
	
	#print("SOME DATA: ", peer)
	#var data = database.peer
	#for d in data[1].data.row:
	#	print(d)
	#""" # 3.x version code
	#database.close()

func auth_error(_object: Dictionary) -> void:
	pass

func data_received(_error: int, _transaction: int, datas: Array) -> void:
	print("TRANSACTED: ", datas)
#	for d in datas[1].data_row: # peer.get_data(32):
#		print("DATA: ", d)
	database.op.close.the_connection()

func connection_error() -> void:
	print("BANNED")

func connection_closed(_clean: bool) -> void:
	print("CLOSED")
