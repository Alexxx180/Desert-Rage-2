extends RefCounted

class_name PollResponse

enum { STATUS = 0, VALUE = 1 }

var buffer: SecureDataBuffer = SecureDataBuffer.new()
var crypto: CryptoConnection = CryptoConnection.new()

func next_etape() -> void:
	if not buffer.secure_connection():
		var startup: PackedByteArray = buffer.backend.op.renew_startup()
		crypto.connection.peers.stream.peer.put_data(startup)
		#crypto.connection.peers.put_data()
	crypto.connection.meta.state.next_etape = false

func connection_attempt() -> void:
	crypto.update()

func transfer_data() -> void:
	var peers: TransferPeers = crypto.connection.peers
	var response: Array = [OK, buffer.backend.op.empty]
	
	if not peers.connected():
		response = peers.get_response_by("protocol", "")
	elif peers.available():
		response = peers.get_response_by("protocol")
	
	if response[STATUS] == OK:
		buffer.backend.responser.parse(response[VALUE])
	else:
		crypto.connection.note.warn("no_data")

func put_startup_message() -> void:
	crypto.connection.peers.put_data(buffer.backend.op.startup)
	crypto.connection.meta.state.ssl = PeerStreamsStatus.FINISH

func _set_service(peers: TransferPeers, service: Variant) -> void:
	if service:
		peers.stream.by("ssl").put_data(service)

func listen_connection() -> void:
	var peers: TransferPeers = crypto.connection.peers
	var response: Array = peers.get_response_by("ssl") # ssl_peers()
	var message: PackedByteArray = response[VALUE]

	if response[STATUS] == OK and 0 < message.size():
		_set_service(peers, buffer.backend.responser.parse(message))
