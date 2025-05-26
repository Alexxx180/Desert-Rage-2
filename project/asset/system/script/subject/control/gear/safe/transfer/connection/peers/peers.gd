extends RefCounted

class_name TransferPeers

var stream: PeerStreams = PeerStreams.new()

func available(protocol: String = PeerStreams.PROTOCOL):
	return stream.with_protocol(protocol).get_available_bytes()

func get_from(peers) -> Array:
	return peers.get_data(peers.get_available_bytes())

func get_response(protocol: String = PeerStreams.PROTOCOL) -> Array:
	return get_from(stream.with_protocol(protocol))

func put_data(data: PackedByteArray) -> void:
	stream.by().put_data(data)

func connect_to(message: String) -> void:
	stream.by().connect_to_stream(stream.peer, message)

func connected() -> bool:
	return ConnectionClient.connection_present(stream.by())

func handshakes() -> bool:
	var s = stream.by()
	return s.get_status() in [s.STATUS_HANDSHAKING, s.STATUS_CONNECTED]

func poll() -> void:
	if handshakes(): stream.by().poll()

func startup_ready() -> bool:
	return stream.ssl.is_connecting() and connected()
