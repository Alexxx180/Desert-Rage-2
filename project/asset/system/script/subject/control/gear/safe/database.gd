extends Node

const PREFIX: String = "postgresql://"

#@onready var database: Node = $client
var database: PostgreSQLClient = PostgreSQLClient.new()

var session: Dictionary = {
	"user": "postgres", "word": "l1F3tpI9geR",
	"port": 5432, "database": "postgres"
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
	database.op.connection.to_host(PREFIX + _get_connection_string(), TransactionRollback.SSL)

func _physics_process(_delta: float) -> void:
	database.op.poll.poll()

func connection_established() -> void:
	print("HAVE CONNECTION")
	var status = database.execute("BEGIN; SELECT * FROM hero;")
	print("STATUS: ", status)
	for d in status:
		print(d)
	
	"""
	var data = database.peer
	for d in data[1].data.row:
		print(d)
	""" # 3.x version code
	#database.close()

func auth_error(_object: Dictionary) -> void:
	pass

func data_received(_errors: Dictionary, _transaction: int, datas: Array) -> void:
	print("TRANSACTED: ", datas)
	database.close()

func connection_error() -> void:
	print("BANNED")
	pass

func connection_closed() -> void:
	print("CLOSED")
	pass
