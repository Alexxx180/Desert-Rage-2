extends RefCounted

class_name PostgreProtocolVersion

enum { ZEROS = 2, VERSION = 3 } ## PostgreSQL protocol ver. number (minor.major) for backend connection.

static func _pad(number: int) -> String: return str(number).pad_zeros(ZEROS)

static func parse(buffer: StreamPeerBuffer) -> void:
	var major: int = int(VERSION)
	var minor: int = major - VERSION
	for character in _pad(major) + _pad(minor):
		buffer.put_data(BufferOperations.bytes([character.to_int()]))
