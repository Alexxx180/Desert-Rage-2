extends Node

enum { SECOND = 1, MIN = 2 }

var craft_id: int = Defaults.INT
var _recipes: Array = Defaults.ARRAY

func check(items: Array, search: Callable, flow: Callable, offset: int) -> bool:
	for i in range(offset, len(items)):
		if search.call(items, i):
			flow.call(i)
			return true
	return false

func matches(logic: Node, items: Array) -> bool:
	var products: Dictionary = logic.items.items.crafting.craft
	return products[craft_id].i.size() == items.size()

func first(items: Array, i: int) -> bool: return items[i] in _recipes

func other(items: Array, i: int) -> bool:
	return craft_id in _craft(items[i]).o

func set_id(id: int) -> void: craft_id = id

func _craft(entry: Dictionary) -> Dictionary: return entry.item.item.craft

func recipe(items: Array) -> Array:
	_recipes = _craft(items[SECOND]).o
	var first = _craft(items.front()).o
	return first
