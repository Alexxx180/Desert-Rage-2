extends RefCounted

class_name PeerStreams

const PROTOCOL: String = "tls"

var peer: StreamPeer
var packet: PacketPeerStream = PacketPeerStream.new()
var _protocols: Dictionary = { "tls": StreamPeerTLS.new() }

var ssl: PeerStreamsStatus = PeerStreamsStatus.new()

var with: Dictionary = {
	"stream": func(protocol): return _protocols[protocol],
	"connection": func(protocol): return storage(_connection(protocol), protocol),
	"ssl": func(protocol): return storage(ssl.is_start(), protocol)
}

func set_client(client: StreamPeerTCP) -> void:
	packet.set_stream_peer(client)
	peer = packet.stream_peer

func _connection(name: String) -> bool:
	return ConnectionClient.connection_present(_protocols[name])

func storage(condition: bool, protocol: String = PROTOCOL):
	return _protocols[protocol] if condition else peer

func with_protocol(protocol: String = ""):
	return storage(protocol != "", protocol)

func by(kind: String = "stream"):
	return with[kind].call(PROTOCOL)
