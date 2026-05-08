extends RefCounted

class_name CraftingItems

var craft: Dictionary = {}
var items: Array = []

func in_items(id: int) -> bool: return id in items
func push_back(id: int) -> void:
	if not in_items(id):
		items.push_back(id)

func _add_item(c: Array, id: int) -> void:
	for o in c:
		craft[o].i.push_back(o)
	push_back(id)

func _connect_ingredients(c: Dictionary, id: int) -> void:
	if c.has("o"):
		_add_item(c.o, id)
	else:
		craft[c.i].o = id

func _set_craft(type, base: int) -> void:
	for j in type.size:
		var i: Item = type.effect[j].item
		if i.craft != Def.DICT:
			print("CRAFT ITEM: ", i.name)
			_connect_ingredients(i.craft, base + j) #craft

func _init(items: GameItems) -> void:
	items.weapon.crafts(craft)
	var n: int = 0
	for i in ["keys", "uses"]:
		var type = items.get(i)
		_set_craft(type, n)
		n += type.size
	print("craft: ", craft)
