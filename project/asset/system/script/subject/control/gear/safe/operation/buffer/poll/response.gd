extends RefCounted

class_name PollResponse

enum { STATUS = 0, VALUE = 1 }

var buffer: SecureDataBuffer

func _valid(response: Array) -> bool:
	return response[STATUS] == OK

func next_etape() -> void:
	if not buffer.secure_connection():
		var s = Transfer.renew(buffer.backend.op.startup, buffer.backend.op.empty)
		buffer.backend.connection.peers.put_data(s)
	buffer.backend.connection.meta.state.next_etape = false

func put_startup_message() -> void:
	var link: ConnectionMetadata = buffer.backend.connection
	link.peers.put_data(buffer.backend.op.startup)
	link.meta.state.ssl = PeerStreamsStatus.FINISH

func busy_connection() -> void:
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

func _set_service(peers: TransferPeers, service: Variant) -> void:
	if service:
		peers.stream.by("ssl").put_data(service)

func check() -> void:
	var peers: TransferPeers = buffer.backend.connection.peers
	var storage: Variant = peers.stream.by("ssl") # ssl_peers()
	var response: Array = peers.get_from(storage)
	var text: PackedByteArray = response[VALUE]

	if _valid(response) and text.size() == 0:
		_set_service(peers, buffer.backend.responser.parse(text))
