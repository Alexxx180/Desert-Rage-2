extends RefCounted

class_name PostgresGeometryTypes

enum { POINT = 600, BOX = 603, LSEG = 601, LINE = 628, CIRCLE = 718 } # Universal Unique IDentifier # Geometry # Date-time

var add: PostgresGeometryRecognize = PostgresGeometryRecognize.new()

func resolve(object: Dictionary) -> bool:
	match object.type_id:
		"tsvector": add.tsvector(object)
		"tsquery": add.tsquery(object)
		POINT: add.point(object)
		BOX: add.box(object)
		LSEG: add.lseg(object)
		"POLYGON": add.path(object)
		"PATH": add.path(object)
		LINE: add.line(object)
		CIRCLE: add.circle(object)
		_: return false
	return true
