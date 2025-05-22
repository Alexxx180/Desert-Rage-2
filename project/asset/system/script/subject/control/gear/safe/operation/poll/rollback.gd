extends RefCounted

class_name TransactionRollback

# To avoid confusion - request codes aren't same as any protocol ver. number.
enum { CANCEL = 80877102, SSL = 80877103, GSSAPI = 80877104 } ## Encryption: insecure, SSL/TLS, GSSAPI
# Significant pair of 16 bits: 1234 the most; the least: 5678 # 5679 # 5680
var methods: Dictionary = {
	SSL: set_ssl_connection, # GSSAPI: set_gssapi_connection # No use.
}
var secure: int = CANCEL

var connection: ConnectionMetadata
var op: BufferOperations

func change_security(method: int) -> void: secure = method

func set_buffered_data(request: int, before: Callable, after: Callable) -> void:
	if not connection.client.connected(): connection.note.fail("no_connection"); return
	var buffer: StreamPeerBuffer = StreamPeerBuffer.new()
	before.call(buffer) # Message length bytes with self.
	buffer.put_data(op.reverse(request, op.put_32))
	after.call(buffer)

func before_connect(b: StreamPeerBuffer) -> void: b.put_data(op.reverse(8, op.put_u32))
func after_connect(b: StreamPeerBuffer) -> void: connection.peers.peer.put_data(b.data_array)
func set_connection(request: int) -> void:
	set_buffered_data(request, before_connect, after_connect)

func set_ssl_connection() -> void:
	if connection.peers.handshakes(): connection.note.warn("already_secure")
	else: set_connection(SSL)

func set_gssapi_connection() -> void:
	set_connection(GSSAPI)

func before_rollback(b: StreamPeerBuffer) -> void:
	b.put_u32(16)
	b.put_data(BackendResponses.reverse_data(b.data_array.duplicate()))

func rollback(process: Dictionary, _method: int) -> void: ## Abort changes made to DB since last Commit.
	set_buffered_data(CANCEL, before_rollback, func(b):
		b.put_u32(process.id) # The process ID of ...
		b.put_u32(process.key) # The secret key for ...
		connection.peers.peer.put_data(b.data_array.slice(4))) # ... the target backend

func next_etape() -> void:
	if not connection.state.next_etape: return
	if methods.has(secure):
		methods[secure].call()
	else:
		connection.peers.put_data(op.startup)
		op.startup = op.empty
	connection.state.next_etape = false
