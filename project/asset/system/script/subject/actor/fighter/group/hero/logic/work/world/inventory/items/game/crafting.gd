extends RefCounted

class_name CraftingItems

var craft: Dictionary = {}

func _connect_ingredients(c: Dictionary, j: int, n: int) -> void:
	if c.has("o"):
		for o in c.o: craft[o].i.push_back(j + n)
	else:
		craft[c.i].o = j + n

func _set_craft(type, n: int) -> void:
	for j in type.size:
		var c: Dictionary = type.names[j].craft
		if c != Defaults.DICT:
			_connect_ingredients(c, j, n)

func _init(items: GameItems) -> void:
	Item.crafts(craft)
	var n: int = 0
	for i in ["keys", "uses"]:
		var type = items.get(i)
		_set_craft(type, n)
		n += type.size
