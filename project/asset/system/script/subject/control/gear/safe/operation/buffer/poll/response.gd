extends RefCounted

class_name PollResponse

enum { STATUS = 0, VALUE = 1 }

var buffer: SecureDataBuffer

func _set_service(storage: Variant, service: Variant) -> void:
	if service: storage.put_data(service)

func _valid(response: Array) -> bool:
	return response[STATUS] == OK

func next_etape() -> void:
	if not buffer.secure_connection():
		var s = Transfer.renew(buffer.backend.op.startup, buffer.backend.op.empty)
		buffer.backend.connection.peers.put_data(s)
	buffer.backend.connection.meta.state.next_etape = false

func check() -> void:
	var peers: TransferPeers = buffer.backend.connection.peers
	var storage: Variant = peers.stream.with_protocol() # ssl_peers()
	var response: Array = peers.get_from(storage)
	var text: PackedByteArray = response[VALUE]

	if _valid(response) and 0 < text.size():
		_set_service(storage, buffer.backend.responser.parse(text))

func put_startup_message() -> void:
	var link: ConnectionMetadata = buffer.backend.connection
	link.peers.put_data(buffer.backend.op.startup)
	link.meta.state.ssl = PeerStreamsStatus.FINISH

func start() -> void:
	var peers: TransferPeers = buffer.backend.connection.peers
	var response: Array = [OK, buffer.backend.op.empty]
	
	if peers.connected():
		if peers.available():
			response = peers.get_response()
	else:
		response = peers.get_response("")
	
	if _valid(response):
		buffer.backend.responser.parse(response[VALUE])
	else:
		buffer.backend.connection.note.warn("no_data")
