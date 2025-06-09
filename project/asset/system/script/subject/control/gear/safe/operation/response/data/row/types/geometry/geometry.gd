extends RefCounted

class_name PostgresGeometryTypes

enum { POINT = 600, BOX = 603, LSEG = 601, LINE = 628, CIRCLE = 718 } # Universal Unique IDentifier # Geometry # Date-time

var recognize: GeometryPostgres = GeometryPostgres.new()

func resolve(object: Dictionary) -> bool:
	match object.type_id:
		"tsvector": recognize.tsvector(object)
		"tsquery": recognize.tsquery(object)
		POINT: recognize.point(object)
		BOX: recognize.box(object)
		LSEG: recognize.lseg(object)
		"POLYGON": recognize.path(object)
		"PATH": recognize.path(object)
		LINE: recognize.line(object)
		CIRCLE: recognize.circle(object)
		_: return false
	return true
