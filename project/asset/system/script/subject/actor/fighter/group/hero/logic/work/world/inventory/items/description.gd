extends RefCounted

class_name Item

var type: int
var name: String
var short: String
var description: String

func _init(_type: int, _name: String, _short: String, _desc: String) -> void:
	type = _type
	name = _name
	short = _short
	description = _desc
