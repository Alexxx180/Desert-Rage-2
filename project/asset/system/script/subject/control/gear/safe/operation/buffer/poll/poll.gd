extends RefCounted

class_name PollConnection

var response: PollResponse = PollResponse.new()
var rollback: TransactionRollback = TransactionRollback.new()
var crypto: CryptoConnection = CryptoConnection.new()
var backend: Dictionary: get = _get_backend, set = _set_backend

func _get_backend() -> Dictionary: return response.buffer.backend
func _set_backend(value: Dictionary) -> void:
	crypto.connection = value.connection
	var buffer: SecureDataBuffer = SecureDataBuffer.new()
	buffer.backend = value
	for type in [response, rollback]:
		type.buffer = buffer
	# #rollback.op = value.op

func poll() -> void: ## Poll connection to check incoming messages. Called frequently in a loop before "execute"
	if not backend.connection.poll(): return

	if backend.connection.meta.state.next_etape:
		response.next_etape()

	if backend.connection.peers.stream.ssl.is_crypto():
		crypto.update()

	if backend.connection.is_busy():
		response.check()

	if backend.connection.peers.startup_ready():
		response.put_startup_message()

	if backend.connection.ssl_ready():
		response.start()

