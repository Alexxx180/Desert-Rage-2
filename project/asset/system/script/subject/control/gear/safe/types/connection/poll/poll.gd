extends RefCounted

class_name PollConnection

var response: PollResponse = PollResponse.new()
var rollback: RollbackTransaction = RollbackTransaction.new()
var crypto: CryptoConnection = CryptoConnection.new()

func poll() -> void: ## Poll connection to check incoming messages. Called frequently in a loop before "execute"
	if response.poll(): return
	rollback.next_etape()
	crypto.update()
	response.start()
	response.set_data()
	response.check()
