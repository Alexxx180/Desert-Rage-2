extends RefCounted

class_name ConnectionMetadata

signal auth_error(object: Dictionary)
signal established()
signal data_received(code: int, status: int, data: Array)

var peers: TransferPeers = TransferPeers.new()
var note: PostgreClientNotify = PostgreClientNotify.new()
var client: ConnectionClient = ConnectionClient.new()
var status: ConnectionStatus = ConnectionStatus.new()
var meta: ConnectionParameters = ConnectionParameters.new()

func _init(): peers.stream.set_client(client.tcp)

func establish() -> void: established.emit()

func raise_data(transact_status: int, data: Array) -> void:
	data_received.emit(status.state, transact_status, data)

func reset() -> void: ## Backend runtime parameters. Information about server state.
	meta.reset()
	status.reset()
	peers.stream.ssl.set_start()

func fail_task(task: Callable) -> void:
	status.fail()
	task.call()

func fail_auth() -> void: ## Check unnessary if status != Status.CONNECTED
	fail_task(func(): auth_error.emit(status.error.duplicate()))

func fail(message: String = "", value: String = "") -> void:
	fail_task(func(): if message != "": note.fail(message, value))

func active() -> bool:
	var c = client.connected()
	var p = status.present()
	print(c, p)
	return c and p

func poll() -> bool:
	client.poll()
	return client.connected()

func is_busy() -> bool: return status.present() and meta.state.busy

func ssl_ready() -> bool:
	return not (peers.stream.ssl.is_intermediate() or status.present())
