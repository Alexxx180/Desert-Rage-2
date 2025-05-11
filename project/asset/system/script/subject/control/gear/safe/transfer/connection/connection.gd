extends RefCounted

class_name ConnectionMetadata

signal auth_error(object: Dictionary)
signal established()
signal data_received(error_object, transaction_status, datas)

enum { DISCONNECTED, CONNECTING, CONNECTED, ERROR } ## Status presentation

const PORT: int = 5432 # Default PostgreSQL port
var port: int

var peers: TransferPeers = TransferPeers.new()
var note: PostgreClientNotify = PostgreClientNotify.new()
var client: StreamPeerTCP = StreamPeerTCP.new()
var data: Array = []

var state: Dictionary = { "busy": false, "next_etape": false, "code": ERR_BUSY, "ssl": 0 }
var status: Dictionary = { "link": DISCONNECTED, "data": [], "param": {}, "error": {} }

func renew_data() -> Array:
	var data: Array = connection.data
	connection.data = []
	return data

func _init(): peers.set_stream(client)
func safe() -> Dictionary: return {} ## Secure dictionary as empty if backend disconnected - updates once connection is established.
func reset_error() -> void: status.error = safe()
func decide_port(other: String) -> int: port = other.to_int() if other else PORT

func establish() -> void: established.emit()
func raise_data(error, transact, data) -> void: data_received.emit(error, transact, data)

func reset() -> void: ## Backend runtime parameters. Information about server state.
	status.param = safe()
	reset_error()
	status.link = DISCONNECTED
	state.ssl = 0

func not_busy() -> void:
	state.busy = false
	state.next_etape = false

func first_message() -> bool: # Get the fist message of server.
	var ok: bool = state.code == OK
	if ok: next_etape = true
	return ok

func attempt(result) -> bool:
	if client.get_status() == StreamPeerTCP.Status.STATUS_NONE:
		status.code = client.connect_to_host(result.strings[3], port)

func fail_auth() -> void:
	fail() ## Check unnessary if status != Status.CONNECTED
	auth_error.emit(error.duplicate())

func fail(message: String = "", value: String = "") -> void:
	status.link = ERROR
	if message != "": note.fail(message, value)

func succeed() -> void: status.link = CONNECTED

func in_progress() -> bool: return status.link == CONNECTING
func present() -> bool: return status.link == CONNECTED

func connected() -> bool: return client.get_status() == StreamPeerTCP.Status.STATUS_CONNECTED
func hosted() -> bool: return client.is_connected_to_host()
func active() -> bool: return hosted() and connected() and present()

func poll() -> bool:
	client.poll()
	return not connected()

func ssl_ready() -> bool: return not (state.ssl in [1, 2] or present())
func ssl_peers(): return peers.by_ssl(state.ssl)
func startup_ready(): return state.ssl == 2 and peers.connected()
