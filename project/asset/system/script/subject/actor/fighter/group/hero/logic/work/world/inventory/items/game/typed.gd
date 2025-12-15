extends RefCounted

class_name TypeItems

func get_item(no: int) -> Dictionary:
	return { "logic": effect[no], "item": names[no] }

func _init() -> void: size = names.size()

func _icon(path: String) -> String: return path
func _type(short: String) -> String: return short

func _slot(name: String, type: String, description: String, icon: String) -> Item:
	return Item.new(name, _type(type), description, _icon(icon))

var size: int
var effect: Array
var names: Array[Item]
