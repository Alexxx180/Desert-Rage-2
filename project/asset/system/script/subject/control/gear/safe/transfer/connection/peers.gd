extends RefCounted

class_name TransferPeers

const PROTOCOL: String = "tls"

var packet_stream: PacketPeerStream = PacketPeerStream.new()
var stream: Dictionary = { "tls": StreamPeerTLS.new(), "ssl": StreamPeerSSL.new() }
var peer: StreamPeer

func set_stream(client) -> void:
	packet_stream.set_stream(client)
	peer = packet_stream.stream

func _storage(condition: bool, protocol: String = PROTOCOL):
	return stream[protocol] if condition else peer

func by_stream(protocol: String = PROTOCOL): return stream[protocol]
func by_connection(protocol: String): return _storage(connected(protocol), protocol)
func by_ssl(ssl: int, protocol: String = "tls"): return _storage(ssl == 0, protocol)

func available(protocol: String = ""):
	var p = _storage(protocol != "", protocol)
	return p.get_available_bytes()

func get_from(peers) -> Array:
	return peers.get_data(peers.get_available_bytes())

func get_response(protocol: String = "") -> Array:
	var p = _storage(protocol != "", protocol)
	return get_from(p)

func put_data(data: PackedByteArray) -> void:
	stream[PROTOCOL].put_data(data)

func connect(message: String, protocol: String = PROTOCOL) -> void:
	stream[protocol].connect_to_stream(peer, message)

func connected(protocol: String = PROTOCOL) -> bool:
	return stream[protocol].get_status() == stream[protocol].STATUS_CONNECTED

func handshakes(protocol: String = PROTOCOL) -> bool:
	var s = stream[protocol]
	var _status = s.get_status()
	return (_status == s.STATUS_HANDSHAKING or _status == s.STATUS_CONNECTED)

func poll() -> void: if handshakes(): by_stream().poll()
