extends RefCounted

class_name CraftingItems

var craft: Dictionary = {}
var items: Array = []

func in_items(id: int) -> bool: return id in items

func _add_item(c: Array, next: int) -> void:
	for o in c:
		craft[o].i.push_back(next)
		if not in_items(next):
			items.push_back(next)

func _connect_ingredients(c: Dictionary, j: int, n: int) -> void:
	if c.has("o"):
		_add_item(c.o, j + n)
	else:
		craft[c.i].o = j + n

func _set_craft(type, n: int) -> void:
	for j in type.size:
		var c: Dictionary = type.names[j].craft
		if c != Defaults.DICT:
			_connect_ingredients(c, j, n)
	craft

func _init(items: GameItems) -> void:
	Item.crafts(craft)
	var n: int = 0
	for i in ["keys", "uses"]:
		var type = items.get(i)
		_set_craft(type, n)
		n += type.size
