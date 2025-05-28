extends RefCounted

class_name SecureDataBuffer

var backend: Dictionary
var methods: Dictionary = { SSL: set_ssl_connection } # GSSAPI: set_gssapi_connection # No use.
var secure: int = CANCEL

enum { CANCEL = 80877102, SSL = 80877103, GSSAPI = 80877104 } ## Encryption: insecure, SSL/TLS, GSSAPI
# To avoid confusion - request codes aren't same as any protocol ver. number.
# Significant pair of 16 bits: 1234 the most; the least: 5678 # 5679 # 5680

func set_buffered_data(request: int, before: Callable, after: Callable) -> void:
	if not backend.connection.client.connected():
		backend.connection.note.fail("no_connection")
		return

	var buffer: StreamPeerBuffer = StreamPeerBuffer.new()
	before.call(buffer) # Message length bytes with self.
	buffer.put_data(backend.op.reverse(request, backend.op.put_32))
	after.call(buffer)

func before_connect(b: StreamPeerBuffer) -> void:
	b.put_data(backend.op.reverse(8, backend.op.put_u32))

func after_connect(b: StreamPeerBuffer) -> void:
	backend.connection.peers.stream.peer.put_data(b.data_array)

func set_connection(request: int) -> void:
	set_buffered_data(request, before_connect, after_connect)

func change_security(method: int) -> void:
	secure = method

func secure_connection() -> bool:
	var has: bool = methods.has(secure)
	if has: methods[secure].call()
	return has

func set_ssl_connection() -> void:
	if backend.connection.peers.handshakes():
		backend.connection.note.warn("already_secure")
	else:
		# backend.connection.peers.stream.ssl.set_crypto()
		set_connection(SSL)

func set_gssapi_connection() -> void:
	set_connection(GSSAPI)
