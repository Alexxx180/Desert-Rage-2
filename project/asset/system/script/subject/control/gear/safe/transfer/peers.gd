extends RefCounted

class_name TransferPeers

var packet_stream: PacketPeerStream = PacketPeerStream.new()
var stream_tls: StreamPeerTLS = StreamPeerTLS.new()
var peer: StreamPeer

func set_stream(client) -> void:
	packet_stream.set_stream(client)
	peer = packet_stream.stream

func _storage(condition: bool):
	return stream_tls if condition else peer

func by_connection():
	return _storage(stream_tls.get_status() == StreamPeerTLS.STATUS_CONNECTED)

func by_ssl(ssl: int):
	return _storage(ssl == 0)

func connected() -> bool:
	return stream_tls.get_status() == stream_peer_tls.STATUS_CONNECTED

func handshakes() -> bool:
	var _status = stream_tls.get_status()
	return (_status == stream_tls.STATUS_HANDSHAKING and
		_status = stream_tls.STATUS_CONNECTED)
