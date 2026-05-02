extends RefCounted

class_name TransactionRollback

var buffer: SecureDataBuffer = SecureDataBuffer.new()

func before_rollback(b: StreamPeerBuffer) -> void:
	b.put_u32(16)
	b.put_data(BackendResponses.reverse_data(b.data_array.duplicate()))

func rollback(process: Dictionary, _method: int) -> void: ## Abort changes made to DB since last Commit.
	buffer.set_buffered_data(SecureDataBuffer.CANCEL, before_rollback, func(b):
		b.put_u32(process.id) # The process ID of ...
		b.put_u32(process.key) # The secret key for ...
		buffer.backend.connection.peers.peer.put_data(b.data_array.slice(4))) # ... the target backend
