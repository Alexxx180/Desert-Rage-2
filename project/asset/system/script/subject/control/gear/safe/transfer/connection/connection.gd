extends RefCounted

class_name ConnectionMetadata

signal auth_error(object: Dictionary)
signal established()
signal data_received(error_object, transaction_status, datas)

var peers: TransferPeers = TransferPeers.new()
var note: PostgreClientNotify = PostgreClientNotify.new()
var client: ConnectionClient = ConnectionClient.new()
var status: ConnectionStatus = ConnectionStatus.new()

var state: Dictionary = { "busy": false, "next_etape": false }
var result: Dictionary = { "data": [], "param": {}, "error": {} }

func renew_data() -> Array:
	var next: Array = result.data
	result.data = []
	return next

func _init(): peers.set_stream(client.tcp)
func safe() -> Dictionary: return {} ## Secure dictionary as empty if backend disconnected - updates once connection is established.
func reset_error() -> void: result.error = safe()

func establish() -> void: established.emit()
func raise_data(error, transact, d) -> void: data_received.emit(error, transact, d)

func reset() -> void: ## Backend runtime parameters. Information about server state.
	status.param = safe()
	reset_error()
	status.reset()
	peers.ssl = 0

func not_busy() -> void:
	state.busy = false
	state.next_etape = false

func first_message() -> bool: # Get the fist message of server.
	var ok: bool = client.state == OK
	if ok: state.next_etape = true
	return ok

func fail_auth() -> void:
	status.fail() ## Check unnessary if status != Status.CONNECTED
	auth_error.emit(status.error.duplicate())

func fail(message: String = "", value: String = "") -> void:
	status.fail()
	if message != "": note.fail(message, value)

func active() -> bool: return client.all_set() and status.present()
func ssl_ready() -> bool: return peers.ssl_ready() and not status.present()
