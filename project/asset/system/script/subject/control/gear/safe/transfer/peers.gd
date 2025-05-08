extends RefCounted

class_name TransferPeers

var packet_stream: PacketPeerStream = PacketPeerStream.new()
var stream: Dictionary = { "tls": StreamPeerTLS.new(), "ssl": StreamPeerSSL.new() }
var peer: StreamPeer

func set_stream(client) -> void:
	packet_stream.set_stream(client)
	peer = packet_stream.stream

func _storage(condition: bool, protocol: String = "tls"):
	return stream[protocol] if condition else peer

func by_connection(protocol: String): return _storage(connected(protocol), protocol)
func by_ssl(ssl: int, protocol: String = "tls"): return _storage(ssl == 0, protocol)

func connected(protocol: String = "tls") -> bool:
	return stream[protocol].get_status() == stream[protocol].STATUS_CONNECTED

func handshakes(protocol: String = "tls") -> bool:
	var _status = stream[protocol].get_status()
	return (_status == stream[protocol].STATUS_HANDSHAKING and
		_status = stream[protocol].STATUS_CONNECTED)
