extends RefCounted

class_name Item

var name: String
var short: String
var description: String
var icon: String
var craft: Dictionary

func _init(_name: String, _short: String, _desc: String, _icon: String, _craft: Dictionary = Defaults.DICT) -> void:
	name = _name
	short = _short
	description = _desc
	icon = _icon
	craft = _craft
