extends RefCounted

class_name PostgresBytesTypes

enum { BITEA = 17, CIDR = 650, INET = 869, MACADDR = 829, MACADDR8 = 774, BIT = 1560, BIT_VARYING = 1562, DATE = 1082, TIME = 1266 } # Byte array # Network masks # Bit

var add: PostgresBytesRecognize = PostgresBytesRecognize.new()

func resolve(object: Dictionary) -> void:
	match object.type_id:
		BIT: add.latin(object)
		BIT_VARYING: add.latin(object)
		BITEA: add.bitea(object)
		CIDR: add.ip_address(object)
		INET: add.ip_address(object)
		MACADDR: add.latin(object)
		MACADDR8: add.latin(object)
		DATE: add.latin(object)
		TIME: add.latin(object)
		UUID: add.latin(object)
		_: return false
	return true
