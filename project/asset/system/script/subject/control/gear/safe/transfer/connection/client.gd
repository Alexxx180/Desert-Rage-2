extends RefCounted

class_name ConnectionClient

const PORT: int = 5432 # Default PostgreSQL port

var tcp: StreamPeerTCP = StreamPeerTCP.new()
var state: int = FAILED
var port: int = PORT

func poll() -> void: tcp.poll()

func decide_port(other: String) -> void:
	if other: port = other.to_int()

func attempt(host: String) -> void:
	if no_connection():
		state = tcp.connect_to_host(host, port)
		print("CLIENT STATE: ", state)
	else:
		print("CLIENT ALREADY CONNECTED")

func no_connection() -> bool:
	return tcp.get_status() == StreamPeerTCP.Status.STATUS_NONE

func connected() -> bool:
	return tcp.get_status() == StreamPeerTCP.Status.STATUS_CONNECTED

func hosted() -> bool:
	return tcp.is_connected_to_host()

func all_set() -> bool:
	return hosted() and connected()
