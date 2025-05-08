extends RefCounted

class_name PostgreSQLDataTypes

var add: PostgreSQLTypeRecognize = PostgreSQLTypeRecognize.new()
var query_result: PostgreSQLQueryResult = PostgreSQLQueryResult.new()

enum { # Sorted data types
	BOOLEAN = 16, SMALLINT = 21, INTEGER = 23, BIGINT = 20, REAL = 700, DOUBLE_PRECISION = 701,
	# Boolean # Integer # Floating point value
	TEXT = 25, CHARACTER = 1042, CHARACTER_VARYING = 1043, JSON_ = 114, JSONB = 3802, XML = 142,
	# String - CHARacter, VARyingCHARacter # Schemas: JSON # XML
	BITEA = 17, CIDR = 650, INET = 869, MACADDR = 829, MACADDR8 = 774,
	# Byte array # Network masks #
	BIT = 1560, BIT_VARYING = 1562, UUID = 2950,
	# Bit # Universal Unique IDentifier
	POINT = 600, BOX = 603, LSEG = 601, LINE = 628, CIRCLE = 718,
	# Geometry
	DATE = 1082, TIME = 1266
}

var _stop: bool
var row: Array
var value_data
var responses: BackendResponses

func _match_types(i: int) -> bool:
	match query_result.get_type_object_id(i):
		BOOLEAN: _stop = add.boolean(row, value_data[0])
		SMALLINT: add.int(row, value_data)
		INTEGER: add.int(row, value_data)
		BIGINT: add.int(row, value_data)
		"DECIMAL": add.float(row, value_data)
		"NUMERIC": add.float(row, value_data)
		REAL: add.float(row, value_data)
		DOUBLE_PRECISION: add.float(row, value_data)
		"SMALLSERIAL": add.int(row, value_data)
		"SERIAL": add.int(row, value_data)
		"BIGSERIAL": add.int(row, value_data)
		TEXT: add.string(row, value_data)
		CHARACTER: add.string(row, value_data)
		CHARACTER_VARYING: add.string(row, value_data)
		"tsvector": add.tsvector(row, value_data, responses)
		"tsquery": add.tsquery(row, value_data, responses)
		XML: _stop = add.xml(row, value_data, responses)
		JSON_: _stop = add.json(row, value_data, responses)
		JSONB: _stop = add.json_binary(row, value_data, responses)
		BIT: row.append(value_data.get_string_from_ascii())
		BIT_VARYING: row.append(value_data.get_string_from_ascii())
		BITEA: _stop = add.bitea(row, value_data, responses)
		"TIMESTAMP": add.timestamp(row, value_data, responses)
		"INTERVAL": add.interval(row, value_data, responses)
		UUID: add.latin(row, value_data)
		CIDR: add.ip_address(row, value_data)
		INET: add.ip_address(row, value_data)
		MACADDR: add.latin(row, value_data)
		MACADDR8: add.latin(row, value_data)
		POINT: _stop = add.point(row, value_data, responses)
		BOX: add.box(row, value_data, responses)
		LSEG: _stop = add.lseg(row, value_data, responses)
		"POLYGON": add.path(row, value_data, responses)
		"PATH": add.path(row, value_data, responses)
		LINE: _stop = add.line(row, value_data, responses)
		CIRCLE: _stop = add.circle(row, value_data, responses)
		DATE: add.latin(row, value_data)
		TIME: add.latin(row, value_data)
		_: row.append(value_data) # PackedByteArray

func data_row_response() -> bool: # Identifies the message as a data row. Number of column values that follow - can be 0.
	var _stop: bool = false
	var number_of_columns = responses.reverse(5, 7, 4)
	number_of_columns = buffer.get_16()
	
	row = []
	var raw_row := []

	var cursor: int = 0
	var i: int = 0
	# Next, the following pair of fields appear for each column.
	while i < number_of_columns and not _stop:
		buffer = StreamPeerBuffer.new()

		var next: int = cursor + 11
		var value_length = responses.reverse(cursor + 7, next, 0)
		var length: int = responses.buffer.get_32()
		
		if length == -1:
			row.append(null)
			raw_row.append(null)
			length = 0 ### NULL ### The result.
		else:
			value_data = responses.slice(next, next + length) # var error: int
			_match_types()
			if not _stop:
				raw_row.append(query_result.verify()
				if query_result.get_type_object_id(i): #/!\ A verif /!\
					raw_row.append(value_data.get_string_from_utf8())
				else: 
					raw_row.append(value_data)
		cursor += length + 4
		i += 1
	if not _stop:
		query_result.data_row.append(row)# The result.
		query_result.raw_data_row.append(raw_row)
	return _stop
