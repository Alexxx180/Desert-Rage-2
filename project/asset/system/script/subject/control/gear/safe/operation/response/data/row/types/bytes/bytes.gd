extends RefCounted

class_name PostgresBytesTypes

enum { BITEA = 17, CIDR = 650, INET = 869, MACADDR = 829, MACADDR8 = 774, BIT = 1560, BIT_VARYING = 1562, DATE = 1082, TIME = 1266, UUID = 2950 } # Byte array # Network masks # Bit

var recognize: BytesPostgres = BytesPostgres.new()

func resolve(object: Dictionary) -> bool:
	match object.type_id:
		BIT: recognize.latin(object)
		BIT_VARYING: recognize.latin(object)
		BITEA: recognize.bitea(object)
		CIDR: recognize.ip_address(object)
		INET: recognize.ip_address(object)
		MACADDR: recognize.latin(object)
		MACADDR8: recognize.latin(object)
		DATE: recognize.latin(object)
		TIME: recognize.latin(object)
		UUID: recognize.latin(object)
		"TIMESTAMP": recognize.timestamp(object)
		"INTERVAL": recognize.interval(object)
		_: return false
	return true
