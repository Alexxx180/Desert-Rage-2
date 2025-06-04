extends RefCounted

class_name ConnectionClient

const PORT: int = 5432 # Default PostgreSQL port

var tcp: StreamPeerTCP = StreamPeerTCP.new()
var state: int = FAILED
var port: int = PORT

func poll() -> void: tcp.poll()
func reset() -> void: state = FAILED

func decide_port(other: String) -> void:
	if other: port = other.to_int()

func attempt(host: String, next_port: String) -> void:
	decide_port(next_port)
	if no_connection():
		state = tcp.connect_to_host(host, port)
		tcp.poll()
		print("CLIENT STATE: ", state)
	else:
		print("CLIENT ALREADY CONNECTED")

func no_connection() -> bool:
	return tcp.get_status() == StreamPeerTCP.Status.STATUS_NONE

static func connection_present(client) -> bool:
	return client.get_status() == client.STATUS_CONNECTED  # StreamPeerTCP.Status.STATUS_CONNECTED

func connected() -> bool: return connection_present(tcp)

func disconnect_from_host() -> void:
	tcp.disconnect_from_host()

func first_message() -> bool: # Get the fist message of server.
	return state == OK
