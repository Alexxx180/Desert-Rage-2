extends RefCounted

class_name TypeItems

func get_item(no: int) -> Dictionary:
	return { "logic": effect[no], "item": names[no] }

func _icon(path: String) -> String: return path
func _type(short: String) -> String: return short

func _item(name: String, type: String, description: String, icon: String, _craft: Dictionary = Defaults.DICT) -> Item:
	return Item.new(name, _type(type), description, _icon(icon), _craft)

func _get_names() -> Array[Item]: return []
func _get_effect() -> Array: return []

func _init() -> void:
	names = _get_names()
	size = names.size()
	effect = _get_effect()

func in_items(id: int) -> bool:
	return origin <= id and id < origin + size

var origin: int
var size: int
var effect: Array
var names: Array[Item]
