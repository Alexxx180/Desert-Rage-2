extends RefCounted

class_name PollConnection

var response: PollResponse = PollResponse.new()
var rollback: TransactionRollback = RollbackTransaction.new()
var crypto: CryptoConnection = CryptoConnection.new()
var backend: Dictionary: set = _set_backend

func _set_backend(backend: Dictionary) -> void:
	response.backend = backend
	for type in [crypto, rollback]:
		type.connection = backend.connection
	rollback.op = backend.op

func poll() -> void: ## Poll connection to check incoming messages. Called frequently in a loop before "execute"
	if response.poll(): return
	rollback.next_etape()
	crypto.update()
	response.start()
	response.set_data()
	response.check()
