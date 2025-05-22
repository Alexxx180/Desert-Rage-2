extends RefCounted

class_name PollConnection

var response: PollResponse = PollResponse.new()
var rollback: TransactionRollback = TransactionRollback.new()
var crypto: CryptoConnection = CryptoConnection.new()
var backend: Dictionary: set = _set_backend

func _set_backend(value: Dictionary) -> void:
	response.backend = value
	for type in [crypto, rollback]:
		type.connection = value.connection
	rollback.op = value.op

func poll() -> void: ## Poll connection to check incoming messages. Called frequently in a loop before "execute"
	if not response.poll(): return
	rollback.next_etape()
	crypto.update()
	response.start()
	response.set_data()
	response.check()
