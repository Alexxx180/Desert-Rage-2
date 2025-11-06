extends RefCounted

class_name ItemDescription

var name: String
var short: String
var description: String

func _init(_name: String, _short: String, _desc: String) -> void:
	name = _name
	short = _short
	description = _desc
